require 'spec_helper'

describe "continuing purchases" do
  let!(:vending_machine){ build :vending_machine }
  let!(:product){ build :product, price_in_pence: 260 }

  context "when I have started a purchase with not enough money" do
    let(:response){
      vending_machine.continue_purchase do |purchase_request|
        purchase_request.pay [TenPence.new]
      end
    }

    before do
      vending_machine.start_purchase product.sku do |purchase_request|
        purchase_request.pay [TwoPounds.new]
      end
    end

    it 'should append the new payment to what I had already paid' do
      expect(response.amount_required_in_pence).to eq 50
      expect(response.paid_in_pence).to eq 210
    end

  end

  context "when I have started a purchase with the correct amount of money" do
    let(:response){
      vending_machine.continue_purchase do |purchase_request|
        purchase_request.pay [TenPence.new]
      end
    }

    before do
      vending_machine.start_purchase product.sku do |purchase_request|
        purchase_request.pay [TwoPounds.new, FifityPence.new]
      end
    end

    it 'should not allow me to call continue_purchase' do
      expect{ response }.to raise_error
    end

  end

  context "when I have started a purchase with the too much money and there is not enough change in the machine" do
    let(:response){
      vending_machine.continue_purchase do |purchase_request|
        purchase_request.pay [TenPence.new]
      end
    }

    before do
      vending_machine.start_purchase product.sku do |purchase_request|
        purchase_request.pay [TwoPounds.new, TwoPounds.new]
      end
    end

    it 'should not allow me to call continue_purchase' do
      expect{ response }.to raise_error
    end

  end
  
end
