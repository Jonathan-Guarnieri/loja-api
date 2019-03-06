require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'VALIDATION' do
    it 'create product sucessfully' do
      product = FactoryBot.build(:product)
      expect{product.save!}.to change{Product.count}.by(1)
    end

    it 'reject negative amount' do
      expect{
        Product.create(:name => "product.name", :purchase_price => 1.25, :sale_price => 1.95, :amount => -1 )
      }.to raise_error("amount can not be negative")
    end
  end
end
