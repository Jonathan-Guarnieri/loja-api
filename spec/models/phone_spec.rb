require 'rails_helper'

RSpec.describe Phone, type: :model do
  describe 'VALIDATION' do
    it 'create phone for a user sucessfully' do
      phone = FactoryBot.create(:phone)
      expect(Contact.last.phones[0].number).to eq(phone.number)
    end
  end
end
