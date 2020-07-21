require 'rails_helper'

RSpec.describe Product, type: :model do
  context "Product Validations" do
    before(:all) do
      @product = build(:product)
    end
    it 'is not valid without item_code' do
      @product.item_code = nil
      expect(@product).to_not be_valid
    end

    it 'is not valid without item_name' do
      @product.item_name = nil
      expect(@product).to_not be_valid
    end

    it 'is not valid without item_size' do
      @product.item_size = nil
      expect(@product).to_not be_valid
    end

    it 'is not valid without item_size_unit' do
      @product.item_size_unit = nil
      expect(@product).to_not be_valid
    end

    it 'is not valid without items_per_case' do
      @product.items_per_case = nil
      expect(@product).to_not be_valid
    end

    it 'is not valid without case_volume' do
      @product.case_volume = nil
      expect(@product).to_not be_valid
    end

    it 'is not valid without case_volume_unit' do
      @product.case_volume_unit = nil
      expect(@product).to_not be_valid
    end

    it 'is not valid without case_weight' do
      @product.case_weight = nil
      expect(@product).to_not be_valid
    end

    it 'is not valid without case_weight_unit' do
      @product.case_weight_unit = nil
      expect(@product).to_not be_valid
    end
  end
  context 'Product persistence' do
    it 'is not valid duplicated name' do
      product = create(:product)
      product_repeated = product.dup
      expect(product_repeated).to_not be_valid
    end
  end
end
