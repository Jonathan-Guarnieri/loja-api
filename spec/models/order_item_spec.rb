require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  describe 'VALIDATION' do
    
    it 'create sucessfully an order item' do
      order_item = FactoryBot.build(:order_item)
      expect{order_item.save!}.to change{OrderItem.count}.by(1)
    end

    it 'denies create order item without order_id' do
      order_item = FactoryBot.build(:order_item, order_id: nil)
      expect{order_item.save!}.to raise_error(/Order must exist/)
    end

    it 'denies create order item without product_id' do
      order_item = FactoryBot.build(:order_item, product_id: nil)
      expect{order_item.save!}.to raise_error(/Product must exist/)
    end
  end 
end
