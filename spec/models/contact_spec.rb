require 'rails_helper'

RSpec.describe Contact, type: :model do
  describe 'VALIDATION' do
    it 'create contact sucessfully' do
      contact = FactoryBot.build(:contact)
      expect{contact.save!}.to change{Contact.count}.by(1)
    end

    it 'return ArgumentError for invalid kind' do
      expect{
        Contact.new(:name => "contact.name", :address => "contact.address", :document => "contact.document", :kind => "invalid kind" )
      }.to raise_error(ArgumentError)
    end

    it "denies contact with invalid CPF" do
      contact = FactoryBot.build(:contact)
      contact.document = "666"
      expect{ contact.save }.not_to change{ Contact.count }
    end
  end
end
