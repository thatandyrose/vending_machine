require 'spec_helper'

describe 'starting purchases' do
  let!(:vending_machine){ build :vending_machine }

  context "when there are no products in the machine" do
    let(:response){
      vending_machine.start_purchase 'some sku' do |purchase_request|
        purchase_request.pay [TwoPounds.new, OnePound.new, TenPence.new]
      end
    }

    it 'should fail the transaction' do
      expect{response}.to raise_error(Errors::NoProductError)  
    end
  end
  
  
  context 'when there are products in the machine' do
    let!(:product){ build :product, price_in_pence: 260 }
    
    before do
      vending_machine.add_products [product]
    end
    
    context 'and some change in the machine' do
      before do
        vending_machine.add_coins [FifityPence.new]  
      end

      context "and I put more then the amount" do

        context "and it requires change the machine does have" do
          let!(:response){
            vending_machine.start_purchase product.sku do |purchase_request|
              purchase_request.pay [TwoPounds.new, OnePound.new, TenPence.new]
            end
          }

          it 'should succeed the transaction' do
            expect(response.transaction_successful).to be_truthy
          end

          it 'should remove product from machine' do
            expect(vending_machine.products.count).to eq 0
          end

          it 'should add coins to the machine' do
            expect(vending_machine.coins.count).to eq 3
            expect(vending_machine.cash_amount_in_pence).to eq 310
          end

          it 'should return the product' do
            expect(response.product).to eq product  
          end

          it 'should return change' do
            expect(response.change.map &:class).to eq [FifityPence]
          end
        end

        context "and it requires change the machine doesnt have" do
          let!(:response){
            vending_machine.start_purchase product.sku do |purchase_request|
              purchase_request.pay [TwoPounds.new, TwoPounds.new]
            end
          }

          it 'should fail the transaction' do
            expect(response.transaction_successful).to be_falsey
          end

          it 'should not remove product from machine' do
            expect(vending_machine.products.count).to eq 1
          end

          it 'should not add coins to the machine' do
            expect(vending_machine.coins.count).to eq 1
            expect(vending_machine.cash_amount_in_pence).to eq 50
          end

          it 'should add error message to response' do
            expect(response.message).to eq "Not enough change in the machine"  
          end

          it 'should return no product' do
            expect(response.product).to be_nil
          end

          it 'should return users coins' do
            expect(response.change.map &:class).to eq [TwoPounds, TwoPounds]
          end
        end

        context "and it does not require change" do
          let!(:response){
            vending_machine.start_purchase product.sku do |purchase_request|
              purchase_request.pay [TwoPounds.new, FifityPence.new, TenPence.new, FifityPence.new]
            end
          }

          it 'should succeed the transaction' do
            expect(response.transaction_successful).to be_truthy
          end

          it 'should remove product from machine' do
            expect(vending_machine.products.count).to eq 0
          end

          it 'should add coins to the machine' do
            expect(vending_machine.coins.count).to eq 4
            expect(vending_machine.cash_amount_in_pence).to eq 310
          end

          it 'should return the product' do
            expect(response.product).to eq product  
          end

          it 'should return superflous coins' do
            expect(response.change.map &:class).to eq [FifityPence]
          end
        end
        
      end
    end
    
    context 'and no change in the machine' do
      
      context "and I put the exact amount in" do
        let!(:response){
          vending_machine.start_purchase product.sku do |purchase_request|
            purchase_request.pay [TwoPounds.new, FifityPence.new, TenPence.new]
          end
        }

        it 'should succeed the transaction' do
          expect(response.transaction_successful).to be_truthy
        end

        it 'should remove product from machine' do
          expect(vending_machine.products.count).to eq 0
        end

        it 'should add coins to the machine' do
          expect(vending_machine.coins.count).to eq 3
          expect(vending_machine.cash_amount_in_pence).to eq 260
        end

        it 'should return the product' do
          expect(response.product).to eq product  
        end
        
      end

      context "and I put less than the amount" do
        let!(:response){
          vending_machine.start_purchase product.sku do |purchase_request|
            purchase_request.pay [TwoPounds.new]
          end
        }

        it 'should not remove product from machine' do
          expect(vending_machine.products.count).to eq 1
        end

        it 'should not add coins to the machine' do
          expect(vending_machine.coins.count).to eq 0
          expect(vending_machine.cash_amount_in_pence).to eq 0
        end

        it 'should fail the transaction' do
          expect(response.transaction_successful).to be_falsey
        end

        it 'should add error message to response' do
          expect(response.message).to eq "£0.60 still required" 
          expect(response.amount_required_in_pence).to eq 60 
        end

        it 'should return no product' do
          expect(response.product).to be_nil
        end

        it 'should return no coins' do
          expect(response.change.count).to eq 0
        end
        
      end

      context "and I put more then the amount" do

        context "and it requires change" do
          let(:response){
            vending_machine.start_purchase product.sku do |purchase_request|
              purchase_request.pay [TwoPounds.new, TwoPounds.new]
            end
          }

          it 'should fail the transaction' do
            expect(response.transaction_successful).to be_falsey
          end

          it 'should not remove product from machine' do
            expect(vending_machine.products.count).to eq 1
          end

          it 'should not add coins to the machine' do
            expect(vending_machine.coins.count).to eq 0
            expect(vending_machine.cash_amount_in_pence).to eq 0
          end

          it 'should add error message to response' do
            expect(response.message).to eq "Not enough change in the machine"  
          end

          it 'should return no product' do
            expect(response.product).to be_nil
          end

          it 'should return users coins' do
            expect(response.change.map &:class).to eq [TwoPounds, TwoPounds]
          end
        end

        context "and it does not require change" do
          let!(:response){
            vending_machine.start_purchase product.sku do |purchase_request|
              purchase_request.pay [TwoPounds.new, FifityPence.new, TenPence.new, FifityPence.new]
            end
          }

           it 'should succeed the transaction' do
            expect(response.transaction_successful).to be_truthy
          end

          it 'should remove product from machine' do
            expect(vending_machine.products.count).to eq 0
          end

          it 'should add coins to the machine' do
            expect(vending_machine.coins.count).to eq 3
            expect(vending_machine.cash_amount_in_pence).to eq 260
          end

          it 'should return the product' do
            expect(response.product).to eq product  
          end

          it 'should return superflous coins' do
            expect(response.change.map &:class).to eq [FifityPence]
          end
        end
        
      end
      
    end
    
  end
end
