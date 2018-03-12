class CashMachine
  def initialize(coins)
    @coins = coins
  end

  def value_in_pence
    @coins.inject(0){|sum,c| sum + c.amount_in_pence }
  end

  def order_by_large_coins
    @coins.sort_by{ |c| c.amount_in_pence }.reverse
  end
end