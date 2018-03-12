class ChangeCalculator
  attr_reader :change

  def initialize(change_required_in_pence, available_coins)
    @change_required_in_pence = change_required_in_pence
    @available_coins = available_coins

    calculate_change if enough_coins_value?
  end

  def calculate_change
    coins_collected = []
    collected_amount = 0
    CashMachine.new(@available_coins).order_by_large_coins.each do |coin|
      
      collected_amount += coin.amount_in_pence
      if collected_amount <= @change_required_in_pence
        coins_collected.push coin
      else
        collected_amount -= coin.amount_in_pence
      end

      break if collected_amount == @change_required_in_pence
    end

    @change = coins_collected if collected_amount == @change_required_in_pence
  end

  def enough_coins_value?
    CashMachine.new(@available_coins).value_in_pence >= @change_required_in_pence
  end
end