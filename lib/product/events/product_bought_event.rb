# frozen_string_literal: true

module Product
  module Events
    class ProductBoughtEvent < Dry::Struct
      include Infrastructure::Types

      attribute :aggregate_type, Infrastructure::Types::String
      attribute :aggregate_uuid, Infrastructure::Types::String
      attribute :quantity, Infrastructure::Types::Int

      def values
        instance_values.without('aggregate_uuid', 'aggregate_type')
      end
    end
  end
end
