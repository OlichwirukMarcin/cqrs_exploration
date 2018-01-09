# frozen_string_literal: true

module Order
  module Domain
    class ProductQuantity < Dry::Struct
      T = Infrastructure::Types

      attribute :id, T::Int
      attribute :price, T::Int
      attribute :quantity, T::Int
    end
  end
end