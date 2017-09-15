# frozen_string_literal: true

module Order
  module Events
    class CouponAppliedEvent < Dry::Struct
      include Infrastructure::Types

      attribute :aggregate_type, Infrastructure::Types::String
      attribute :aggregate_id, Infrastructure::Types::String
      attribute :value, Infrastructure::Types::Int

      def values
        instance_values.without('aggregate_id', 'aggregate_type')
      end
    end
  end
end