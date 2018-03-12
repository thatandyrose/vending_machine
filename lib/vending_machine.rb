require 'errors/over_capacity_error'
require 'errors/no_product_error'
require 'coins/coin'
require 'product'
require 'purchase_response'
require 'purchase_request'

include Coins

class VendingMachine
  attr_reader :coins_capacity
  attr_reader :products_capacity

  def initialize(stock_and_change)
    @coins_capacity = stock_and_change[:coins_capacity]
    @products_capacity = stock_and_change[:products_capacity]
    @coins = []
    @products = []
  end

  def add_coins(new_coins)
    raise Errors::OverCapacityError.new(:coin, new_coins.count) if are_coins_above_capacity?(new_coins.count)
    @coins.concat new_coins
  end

  def add_products(new_products)
    raise Errors::OverCapacityError.new(:product, new_products.count) if are_products_above_capacity?(new_products.count)
    @products.concat new_products
  end

  def coins
    @coins.clone
  end

  def products
    @products.clone
  end

  def start_purchase(product_sku, &block)
    product = @products.select{ |p| p.sku == product_sku }.first
    raise Errors::NoProductError if !product
    
    if @purchase_request
      @purchase_request.product = product
    else
      @purchase_request = PurchaseRequest.new(product)
    end

    block.call @purchase_request
    
    response = PurchaseResponse.new(@purchase_request, self)

    process_purchase_response(response)
    
    response
  end

  def cash_amount_in_pence
    CashMachine.new(@coins).value_in_pence
  end

  private

  def process_purchase_response(purchase_response)
    
    case purchase_response.transaction_status
    when :successful
      @products.delete @purchase_request.product
      @coins.concat @purchase_request.coins
      
      purchase_response.change.each do |coin|
        coin_to_remove = @coins.select{|c|c.amount_in_pence == coin.amount_in_pence}.first
        @coins.delete coin_to_remove
      end
      @purchase_request = nil
    when :not_enough_change_in_machine
      @purchase_request = nil
    end
  end

  def are_coins_above_capacity?(additional_coins_count = 0)
    @coins.count + additional_coins_count > coins_capacity
  end

  def are_products_above_capacity?(additional_products_count = 0)
    @products.count + additional_products_count > products_capacity
  end
end