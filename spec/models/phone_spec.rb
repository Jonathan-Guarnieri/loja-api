require 'rails_helper'

RSpec.describe Phone, type: :model do
  describe 'VALIDATION' do
    it 'create phone for a user sucessfully' do
      phone = FactoryBot.create(:phone, number: "   (049  9-9940 - 7410 ")
      expect(Contact.last.phones[0].number).to eq(phone.number)
    end

    it "denies create for invalid phone" do
      expect{ FactoryBot.create(:phone, number: "invalid phone") }.to raise_error( "phone number is invalid")
    end
  end
end
