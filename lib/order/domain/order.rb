# frozen_string_literal: true

module Order
  module Domain
    class Order
      class << self
        include Infrastructure::Entity

        def create_new_order(params); end
      end
    end
  end
end
