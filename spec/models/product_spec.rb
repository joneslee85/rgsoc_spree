require 'spec_helper'

describe Spree::Product do
  describe '#on_sale?' do
    before do
      @product = FactoryGirl.create(:product)
    end

    context 'master_variant#on_sale is true' do
      before do
        @product.master.on_sale = true
      end

      it 'returns true' do
        expect(@product).to be_on_sale
      end
    end

    context 'master_variant#on_sale is false' do
      before do
        @product.master.on_sale = false
      end

      it 'returns false' do
        expect(@product).not_to be_on_sale
      end
    end
  end

  describe '#on_sale=' do
    before do
      @product = FactoryGirl.create(:product)
      @master  = @product.master
    end

    it 'sets master_variant#on_sale' do
    @product.on_sale = true
    expect(@master).to be_on_sale

    @product.on_sale = false
    expect(@master).not_to be_on_sale
    end
  end
end
