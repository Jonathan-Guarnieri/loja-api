require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'VALIDATION' do
    it 'create product sucessfully' do
      product = FactoryBot.build(:product)
      expect{product.save!}.to change{Product.count}.by(1)
    end

    it 'reject negative amount' do
      expect{
        FactoryBot.create(:product, :amount => -1 )
      }.to raise_error("amount can not be negative")
    end
  end
end
