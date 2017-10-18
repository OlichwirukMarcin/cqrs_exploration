# frozen_string_literal: true

module Product
  module Domain
    class Product < Disposable::Twin
      include Infrastructure::Entity
      feature Default

      property :id
      property :uuid
      property :name
      property :quantity
      property :price

      def self.initialize(model)
        product = new(model)
        product.apply_event(
          ::Product::Events::ProductCreatedEvent.new(
            aggregate_type: to_s.split('::').last.downcase,
            aggregate_uuid: SecureRandom.uuid,
            name: product.name,
            quantity: product.quantity,
            price: product.price
          )
        )
        product
      end

      def update(product_params)
        new_name = product_params['name']
        new_quantity = product_params['quantity']
        new_price = product_params['price']
        event = ::Product::Events::ProductUpdatedEvent.new(
          aggregate_type: self.class.to_s.split('::').last.downcase,
          aggregate_uuid: uuid,
          name: update_attr(name, new_name),
          quantity: update_attr(quantity, new_quantity),
          price: update_attr(price, new_price)
        )
        apply_event(event) unless event.values.empty?
        self
      end

      def buy(bought_quantity)
        apply_event(
          ::Product::Events::ProductBoughtEvent.new(
            aggregate_type: self.class.to_s.split('::').last.downcase,
            aggregate_uuid: uuid,
            quantity: quantity - bought_quantity
          )
        )
        self
      end

      def on_product_created(event)
        self.uuid = event.aggregate_uuid
      end

      def on_product_updated(event)
        update_from_hash(event.values)
      end

      def on_product_bought(event)
        self.quantity = event.quantity
      end

      # @api private
      def update_attr(attr, new_attr)
        attr.eql?(new_attr) ? nil : new_attr
      end
    end
  end
end
