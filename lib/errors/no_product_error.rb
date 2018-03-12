module Errors
  class NoProductError < StandardError
    def initialize
      super "Product does not exist"
    end
  end
end