require_relative 'errors/over_capacity_error'
require_relative 'errors/no_product_error'
require_relative 'errors/purchase_not_in_process_error'
require_relative 'coins/coin'
require_relative 'product'
require_relative 'purchase_response'
require_relative 'purchase_request'
require_relative 'coins/cash_machine'
require_relative 'change_calculator'
require 'money'

I18n.enforce_available_locales = false
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
    
    process_purchase_request
  end

  def continue_purchase(&block)
    raise Errors::PurchaseNotInProcessError if !@purchase_request
    block.call @purchase_request

    process_purchase_request
  end

  def cash_amount_in_pence
    CashMachine.new(@coins).value_in_pence
  end

  private

  def process_purchase_request
    purchase_response = PurchaseResponse.new(@purchase_request, self)
    
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

    purchase_response
  end

  def are_coins_above_capacity?(additional_coins_count = 0)
    @coins.count + additional_coins_count > coins_capacity
  end

  def are_products_above_capacity?(additional_products_count = 0)
    @products.count + additional_products_count > products_capacity
  end
end