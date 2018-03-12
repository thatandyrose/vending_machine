class Product
  attr_reader :sku, :name, :price_in_pence
  def initialize(attrs)
    @sku = attrs[:sku]
    @name = attrs[:name]
    @price_in_pence = attrs[:price_in_pence]
  end
end