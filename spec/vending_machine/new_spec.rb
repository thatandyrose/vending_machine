require 'spec_helper'

describe '#new' do
  context "when I create the machine with a configuration" do
    let!(:config) do
      {
        coins_capacity: 100,
        products_capacity: 100
      }
    end
    let(:vending_machine) { VendingMachine.new config }

    it 'should create object correctly' do
      expect(vending_machine.coins_capacity).to eq 100  
      expect(vending_machine.products_capacity).to eq 100  
    end
  end
end