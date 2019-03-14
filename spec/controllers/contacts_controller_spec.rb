require 'rails_helper'
require 'support/auth_params_helper'

RSpec.describe ContactsController, type: :request do

  #############################################################################
  describe 'GET #index' do
    it "return successfully all contacts" do
      contact_1 = FactoryBot.create(:contact)
      contact_2 = FactoryBot.create(:contact)
      get '/contacts', params: get_auth_params
      response_json = JSON.parse(response.body, symbolize_names: true)
      expect(response_json.size).to eq(2)
      expect(response_json[0][:id]).to eq(contact_1.id)
      expect(response_json[1][:id]).to eq(contact_2.id)
    end
    
    it 'return status 200 :ok' do
      get '/contacts', params: get_auth_params
      expect(response).to have_http_status(:ok)
    end

    it 'return sucessfully nested phones' do
      contact = FactoryBot.create(:contact)
      phone = FactoryBot.create(:phone, contact_id: contact.id)
      get '/contacts', params: get_auth_params
      response_json = JSON.parse(response.body, symbolize_names: true)
      expect( response_json[0][:phones][0][:id] ).to eq(phone.id)
    end
  end

  #############################################################################
  describe 'POST #create' do
    it "Create contact, verify attributes" do
      contact = FactoryBot.build(:contact)
      contact_params = {"contact": contact.as_json}
      post '/contacts', params: contact_params.merge(get_auth_params)
      response_json = JSON.parse(response.body, symbolize_names: true)
      expect(response_json[:name]).to eq(contact.name)
      expect(response_json[:address]).to eq(contact.address)
      expect(response_json[:document]).to eq(contact.document)
      expect(response_json[:kind]).to eq(contact.kind)
    end

    it 'return status 201 :created' do
      contact = FactoryBot.build(:contact)
      contact_params = {"contact": contact.as_json}
      post '/contacts', params: contact_params.merge(get_auth_params)
      expect(response).to have_http_status(:created)
    end

    it 'create nested phone, verify attributes' do
      contact = FactoryBot.build(:contact)
      phone = FactoryBot.build(:phone)
      params = { "contact": contact.as_json.merge( { "phones_attributes": [phone.as_json] } ) }.as_json
      
      post '/contacts', params: params.merge(get_auth_params)
      response_json = JSON.parse(response.body, symbolize_names: true)
      
      expect(response_json[:name]).to eq(contact.name)
      expect(response_json[:address]).to eq(contact.address)
      expect(response_json[:document]).to eq(contact.document)
      expect(response_json[:kind]).to eq(contact.kind)
      # nested:
      expect(response_json[:phones][0][:number]).to eq(phone.number)

    end
  end

  #############################################################################
  describe 'GET #show' do
    it 'return successfully a contact' do
      contact = FactoryBot.create(:contact)
      get "/contacts/#{contact.id}", params: get_auth_params
      response_json = JSON.parse(response.body, symbolize_names: true)
      expect(response_json.size).to eq(8)
      expect(response_json[:id]).to eq(contact.id)
      expect(response_json[:name]).to eq(contact.name)
      expect(response_json[:address]).to eq(contact.address)
      expect(response_json[:document]).to eq(contact.document)
      expect(response_json[:kind]).to eq(contact.kind)
    end

    it 'return status 200 :ok' do
      contact = FactoryBot.create(:contact)
      get "/contacts/#{contact.id}", params: get_auth_params
      expect(response).to have_http_status(:ok)
    end

    it 'return status 404 :not_found' do
      contact = FactoryBot.create(:contact)
      get "/contacts/#{contact.id + 1}", params: get_auth_params
      expect(response).to have_http_status(:not_found)
    end

    it 'return sucessfully a nested phone' do
      phone = FactoryBot.create(:phone, number: "49 9-9900-1111")
      get "/contacts/#{phone.contact_id}", params: get_auth_params
      response_json = JSON.parse(response.body, symbolize_names: true)
      expect(response_json[:phones][0][:number]).to eq("49 9-9900-1111")
    end
  end

  #############################################################################
  describe 'PUT #update' do
    it 'rename a contact' do
      contact = FactoryBot.create(:contact)
      contact.name = "altered name"
      contact_params = {"contact": contact.as_json}
      put "/contacts/#{contact.id}", params: contact_params.merge(get_auth_params)
      response_json = JSON.parse(response.body, symbolize_names: true)
      expect(response_json[:name]).to eq("altered name")
    end

    it 'return status 200 :ok' do
      contact = FactoryBot.create(:contact) 
      contact.name = "altered name"
      contact_params = {"contact": contact.as_json}
      put "/contacts/#{contact.id}", params: contact_params.merge(get_auth_params)
      expect(response).to have_http_status(:ok)
    end

    it 'return status 404 :not_found' do
      contact = FactoryBot.create(:contact)
      contact.name = "altered name"
      contact_params = {"contact": contact.as_json}
      put "/contacts/#{contact.id + 1}", params: contact_params.merge(get_auth_params)
      expect(response).to have_http_status(:not_found)
    end

    it 'update a nested phone number' do
      phone = FactoryBot.create(:phone, number: "49 9-9900-1111")
      phone.number = "49 9-9900-2222"
      params = {"contact": {"phones_attributes": [phone.as_json]}}

      put "/contacts/#{phone.contact_id}", params: params.merge(get_auth_params)
      
      response_json = JSON.parse(response.body, symbolize_names: true)
      expect(response_json[:phones][0][:number]).to eq("49 9-9900-2222")
    end
  end

  #############################################################################
  describe 'DELETE #destroy' do
    it 'delete a contact' do
      contact = FactoryBot.create(:contact)
      delete "/contacts/#{contact.id}", params: get_auth_params
      expect(response).to have_http_status(204)
    end

    it 'return status 204 :no_content' do
      contact = FactoryBot.create(:contact)
      delete "/contacts/#{contact.id}", params: get_auth_params
      expect(response).to have_http_status(:no_content)
    end

    it 'return status 404 :not_found' do
      contact = FactoryBot.create(:contact)
      delete "/contacts/#{contact.id + 1}", params: get_auth_params
      expect(response).to have_http_status(:not_found)
    end

    it 'denies delete if contact has order' do
      contact = FactoryBot.create(:contact)
      FactoryBot.create(:order, contact_id: contact.id)
      expect{ delete "/contacts/#{contact.id}", params: get_auth_params 
      }.to raise_error(/is still referenced from table "orders"/)
    end

    it 'denies delete for seller' do
      contact = FactoryBot.create(:contact)
      expect{ delete "/contacts/#{contact.id}", params: get_auth_params("seller") 
      }.to raise_error(Pundit::NotAuthorizedError)
    end

    it 'delete a nested phone' do
      # cria três phones para um contato, deleta um dos fones e verifica se foi deletado
      phone = FactoryBot.create(:phone)
      2.times do; FactoryBot.create(:phone, contact_id: phone.contact_id); end
      params = {"contact": {"phones_attributes": [{"id":phone.id, "_destroy": "true"}]}}
      put "/contacts/#{phone.contact_id}", params: params.merge(get_auth_params)
      expect(Contact.find(phone.contact_id).phones.count).to eq(2)
    end
  end

end
