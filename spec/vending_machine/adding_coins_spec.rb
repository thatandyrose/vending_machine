require 'spec_helper'

describe "adding coins" do
  let!(:vending_machine){ VendingMachine.new coins_capacity: 2, products_capacity: 100 }
  context 'when the machine is empty' do
    
    context "and I add coins within capacity" do
      before do
        vending_machine.add_coins [1Pence.new, 2Pence.new]
      end

      it 'should add coins' do
        expect(vending_machine.coins).to eq [1Pence.new, 2Pence.new]
      end
    end

    context "when I add coins over capacity" do
      it 'should not add coins' do
        expect{vending_machine.add_coins [1Pence.new, 1Pence.new, 1Pence.new]}.to raise_error
        expect(vending_machine.coins.count).to eq 0
      end
    end

  end

  context 'when the machine already has some coins' do
    before do
      vending_machine.add_coins [1Pound.new]
    end
    
    context "and I add coins within capacity" do
      before do
        vending_machine.add_coins [1Pence.new]
      end

      it 'should add coins' do
        expect(vending_machine.coins).to eq [1Pound.new, 1Pence.new]
      end
    end

    context "when I add coins over capacity" do
      it 'should not add coins' do
        expect{vending_machine.add_coins [1Pence.new, 1Pence.new]}.to raise_error
        expect(vending_machine.coins.count).to eq 1
      end
    end
  end
  
end