require 'coins/cash_machine'

class PurchaseRequest
  attr_reader :product, :coins

  def initialize(product)
    @product = product
    @coins = []
  end

  def pay(coins)
    @coins.concat coins
  end

  def change_required_in_pence
    amount_paid_in_pence - product.price_in_pence
  end

  def amount_required_in_pence
    product.price_in_pence - amount_paid_in_pence
  end

  def requires_change?
    change_required_in_pence > 0 
  end

  def amount_paid_in_pence
    CashMachine.new(@coins).value_in_pence
  end
end