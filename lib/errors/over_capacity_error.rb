module Errors
  class OverCapacityError < StandardError
    def initialize(type, count_to_add)
      msg = "Adding #{count_to_add} #{type}(s) will cause the vending machine to be over capacity. Try adding less #{type}s."
      super msg
    end
  end
end