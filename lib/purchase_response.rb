require 'change_calculator'
require 'money'
I18n.enforce_available_locales = false

class PurchaseResponse
  attr_reader :transaction_status, :change, :amount_required_in_pence

  def initialize(purchase_request, vending_machine)
    @purchase_request = purchase_request
    @vending_machine = vending_machine
    @change = []
    @amount_required_in_pence = purchase_request.amount_required_in_pence
    
    build_status
  end

  def transaction_successful
    @transaction_status == :successful
  end

  def message
    case @transaction_status
    when :requires_more_money
      "#{Money.new(@purchase_request.change_required_in_pence.abs, "GBP").format} still required"
    when :not_enough_change_in_machine
      "Not enough change in the machine"
    end
  end

  def product
    @purchase_request.product if transaction_successful
  end

  private

  def change_calculator
    @change_calculator ||= ChangeCalculator.new(@purchase_request.change_required_in_pence, @purchase_request.coins + @vending_machine.coins)
  end

  def build_status
    if !@purchase_request.requires_change? && @purchase_request.amount_required_in_pence == 0
      @transaction_status = :successful
    else
      if @purchase_request.amount_required_in_pence > 0
        @transaction_status = :requires_more_money
      else
        if change_calculator.change
          @change = change_calculator.change
          @transaction_status = :successful
        else
          @change = @purchase_request.coins
          @transaction_status = :not_enough_change_in_machine
        end
      end
    end
  end
end