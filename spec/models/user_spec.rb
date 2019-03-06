require 'rails_helper'

RSpec.describe User, type: :model do

  describe 'VALIDATION' do
    it 'create user sucessfully' do
      user = FactoryBot.build(:user)
      expect{user.save!}.to change{User.count}.by(1)
    end

    it 'return ArgumentError for invalid role' do
      expect{
        User.new(:name => "user.name", :role => "invalid role", :email => "user.email", :password => "user.password" )
      }.to raise_error(ArgumentError)
    end

    # it 'return ArgumentError for invalid password' do
    # VALIDAÇÃO DO TAMANHO MÍNIMO DA PASSWORD: FAZER NO FRONT-END!!!
    #   expect{FactoryBot.create(:user, password: "")}.to raise_error(ArgumentError)
    # end

  end
end
