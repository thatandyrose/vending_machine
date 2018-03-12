require 'spec_helper'

describe "adding products" do
  let!(:vending_machine){ build :vending_machine, products_capacity: 2 }
  context 'when the machine is empty' do
    
    context "and I add products within capacity" do
      before do
        vending_machine.add_products build_list(:product, 2)
      end

      it 'should add products' do
        expect(vending_machine.products.count).to eq 2
      end
    end

    context "and I add products over capacity" do
      it 'should not add products' do
        expect{ vending_machine.add_products build_list(:product, 3) }.to raise_error(Errors::OverCapacityError)
        expect(vending_machine.products.count).to eq 0
      end
    end

  end

  context 'when the machine has some products already' do
    before do
      vending_machine.add_products [build(:product)]
    end
    
    context "and I add products within capacity" do
      before do
        vending_machine.add_products [build(:product)]
      end

      it 'should add products' do
        expect(vending_machine.products.count).to eq 2
      end
    end

    context "and I add products over capacity" do
      it 'should not add products' do
        expect{ vending_machine.add_products build_list(:product, 2) }.to raise_error(Errors::OverCapacityError)
        expect(vending_machine.products.count).to eq 1
      end
    end
    
  end
end