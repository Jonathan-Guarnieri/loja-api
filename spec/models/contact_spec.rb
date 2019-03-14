require 'rails_helper'

RSpec.describe Contact, type: :model do
  describe 'VALIDATION' do
    it 'create contact sucessfully' do
      contact = FactoryBot.build(:contact)
      expect{contact.save!}.to change{Contact.count}.by(1)
    end

    it 'denies invalid kind' do
      # já levanta o erro no build pois o kind é enum
      expect{ FactoryBot.build(:contact, kind: "invalid kind") }.to raise_error(/is not a valid kind/)
    end

    it "denies invalid document" do
      # levanta erro apenas quando vai salvar (por isso precisa ser create)
      expect{ FactoryBot.create(:contact, document: "000.000.000-00") }.to raise_error("A valid CPF or CNPJ need to be informed")
    end
  end
end
