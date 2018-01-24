# frozen_string_literal: true

module Product
  module Domain
    module Order
      class OrderLine < ::Domain::SchemaStruct
        attribute :id, T::Int
        attribute :order_id, T::Coercible::Int
        attribute :product_id, T::Coercible::Int
        attribute :quantity, T::Coercible::Int
      end
    end
  end
end
