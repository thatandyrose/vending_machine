module Errors
  class PurchaseNotInProcessError < StandardError
    def initialize
      super "Purchase not in process. You nee to call .start_purchase first."
    end
  end
end