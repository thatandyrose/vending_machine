require 'spec_helper'

describe "adding products" do
  let!(:vending_machine){ VendingMachine.new coins_capacity: 100, products_capacity: 2 }
  context 'when the machine is empty' do
    
    context "and I add products within capacity" do
      before do
        vending_machine.add_products [Product.new(sku: 1, name: 'coke'), Product.new(sku: 2, name: 'coke')]
      end

      it 'should add products' do
        expect(vending_machine.products).to eq [Product.new(sku: 1, name: 'coke'), Product.new(sku: 2, name: 'coke')]
      end
    end

    context "and I add products over capacity" do
      it 'should not add products' do
        expect{ vending_machine.add_products [Product.new(sku: 1, name: 'coke'), Product.new(sku: 2, name: 'coke'), Product.new(sku: 3, name: 'crisps')] }.to raise_error
        expect(vending_machine.products.count).to eq 0
      end
    end

  end

  context 'when the machine has some products already' do
    before do
      vending_machine.add_products [Product.new(sku: 1, name: 'coke')]
    end
    
    context "and I add products within capacity" do
      before do
        vending_machine.add_products [Product.new(sku: 2, name: 'coke')]
      end

      it 'should add products' do
        expect(vending_machine.products).to eq [Product.new(sku: 1, name: 'coke'), Product.new(sku: 2, name: 'coke')]
      end
    end

    context "and I add products over capacity" do
      it 'should not add products' do
        expect{ vending_machine.add_products [Product.new(sku: 2, name: 'coke'), Product.new(sku: 3, name: 'crisps')] }.to raise_error
        expect(vending_machine.products.count).to eq 1
      end
    end
    
  end
end