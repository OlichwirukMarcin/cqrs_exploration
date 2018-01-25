# frozen_string_literal: true

module Order
  module CommandHandlers
    class AddProductsCommandHandler
      M = Dry::Monads
      attr_reader :order_repo, :event_repo, :order_summary

      def initialize(order_repo, event_repo, order_summary)
        @order_repo = order_repo
        @event_repo = event_repo
        @order_summary = order_summary
      end

      def execute(command)
        validation_result = command.validate

        return M.Left(validation_result.errors) unless validation_result.success?

        order_id = validation_result.output[:order_id]
        selected_products = validation_result.output[:selected_products]

        order_lines = Order::Domain::OrderLine::Composite
          .from_products(selected_products, order_id)

        order = order_repo.by_id(order_id)
        order.add_products(order_lines)
        order_repo.save(order)

        event_repo.publish(
          Order::Events::Integration::OrderUpdatedIntegrationEvent.new(
            order_uuid: order.uuid,
            total_price: order_summary.total_price(order),
            discount: order_summary.discount(order)
          )
        )

        M.Right(true)
      end
    end
  end
end
