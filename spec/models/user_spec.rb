require 'rails_helper'

RSpec.describe User, type: :model do

  describe 'VALIDATION' do
    it 'create user sucessfully' do
      user = FactoryBot.build(:user)
      expect{user.save!}.to change{User.count}.by(1)
    end

    it 'denies invalid role' do
      expect{ FactoryBot.build(:user, role: "invalid_role") }.to raise_error(/is not a valid role/)
    end

    # email tratado pelo devise
    # password tratada em config/initializers/devise.rb
  end
end
