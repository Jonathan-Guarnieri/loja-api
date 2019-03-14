require 'rails_helper'

RSpec.describe Order, type: :model do
  describe "VALIDATION" do
    
    it "create a order sucessfully" do
      order = FactoryBot.build(:order)
      expect{order.save!}.to change{Order.count}.by(1)
    end

  end
end
