# frozen_string_literal: true

module Product
  module Services
    class UpdateProductService
      M = Dry::Monads
      attr_reader :event_store, :product_repo

      def initialize(event_store, product_repo)
        @event_store = event_store
        @product_repo = product_repo
      end

      def call(params)
        validation_result = Validator.call(params.to_h)
        return M.Left(validation_result) if validation_result.failure?

        product = product_repo.by_id(params[:id])
        product.update(validation_result.output[:product])

        product_repo.update(product)
        event_store.commit(product.events)

        M.Right(true)
      end

      # @api private
      Validator = Dry::Validation.Form do
        configure do
          config.messages = :i18n
        end

        required(:product).schema do
          required(:name).filled(:str?)
          required(:quantity).filled(:int?, gteq?: 0)
          required(:price).filled(:int?, gt?: 0)
        end
      end
    end
  end
end
