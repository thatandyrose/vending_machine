require 'spec_helper'

describe "adding coins" do
  
  let!(:vending_machine){ build :vending_machine, coins_capacity: 2  }
  context 'when the machine is empty' do
    
    context "and I add coins within capacity" do
      before do
        vending_machine.add_coins [OnePence.new, TwoPence.new]
      end

      it 'should add coins' do
        expect(vending_machine.coins.count).to eq 2
      end
    end

    context "when I add coins over capacity" do
      it 'should not add coins' do
        expect{vending_machine.add_coins [OnePence.new, OnePence.new, OnePence.new]}.to raise_error(Errors::OverCapacityError)
        expect(vending_machine.coins.count).to eq 0
      end
    end

  end

  context 'when the machine already has some coins' do
    before do
      vending_machine.add_coins [OnePound.new]
    end
    
    context "and I add coins within capacity" do
      before do
        vending_machine.add_coins [OnePence.new]
      end

      it 'should add coins' do
        expect(vending_machine.coins.count).to eq 2
      end
    end

    context "when I add coins over capacity" do
      it 'should not add coins' do
        expect{vending_machine.add_coins [OnePence.new, OnePence.new]}.to raise_error(Errors::OverCapacityError)
        expect(vending_machine.coins.count).to eq 1
      end
    end
  end
  
end