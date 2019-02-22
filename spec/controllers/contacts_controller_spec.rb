require 'rails_helper'

RSpec.describe ContactsController, type: :request do

  #############################################################################
  describe 'GET #index' do
    it "return successfully all contacts" do
      contact_1 = FactoryBot.create(:contact)
      contact_2 = FactoryBot.create(:contact)
      get '/contacts'
      response_json = JSON.parse(response.body, symbolize_names: true)
      expect(response_json.size).to eq(2)
      expect(response_json[0][:id]).to eq(contact_1.id)
      expect(response_json[1][:name]).to eq(contact_2.name)
    end
    
    it 'return status 200 :ok' do
      get '/contacts'
      expect(response).to have_http_status(:ok)
    end
  end

  #############################################################################
  describe 'POST #create' do
    it "Create contact, verify attributes" do
      contact = FactoryBot.build(:contact)
      contact_params = {"contact": { "name": contact.name, "address": contact.address, "document": contact.document, "kind": contact.kind }}
      post '/contacts', params: contact_params
      response_json = JSON.parse(response.body, symbolize_names: true)
      expect(response_json[:name]).to eq(contact.name)
      expect(response_json[:address]).to eq(contact.address)
      expect(response_json[:document]).to eq(contact.document)
      expect(response_json[:kind]).to eq(contact.kind)
    end

    it 'return status 201 :created' do
      contact = FactoryBot.build(:contact)
      contact_params = {"contact": { "name": contact.name, "address": contact.address, "document": contact.document, "kind": contact.kind }}
      post '/contacts', params: contact_params
      expect(response).to have_http_status(:created)
    end
  end

  #############################################################################
  describe 'GET #show' do
    it 'return successfully a contact' do
      contact = FactoryBot.create(:contact)
      get "/contacts/#{contact.id}"
      response_json = JSON.parse(response.body, symbolize_names: true)
      expect(response_json.size).to eq(8) # 7 (5 attr + 2 created/updated) + 1(:phones) = 8
      expect(response_json[:id]).to eq(contact.id)
      expect(response_json[:name]).to eq(contact.name)
      expect(response_json[:address]).to eq(contact.address)
      expect(response_json[:document]).to eq(contact.document)
      expect(response_json[:kind]).to eq(contact.kind)
    end

    it 'return status 200 :ok' do
      contact = FactoryBot.create(:contact)
      get "/contacts/#{contact.id}"
      expect(response).to have_http_status(:ok)
    end

    it 'return status 404 :not_found' do
      contact = FactoryBot.create(:contact)
      get "/contacts/#{contact.id + 1}"
      expect(response).to have_http_status(:not_found)
    end
  end

  #############################################################################
  describe 'PATCH #update' do ### daqui em diante
    it 'rename a contact' do
      contact = FactoryBot.create(:contact) 
      patch "/contacts/#{contact.id}", params: { "contact": { "name": "altered name" } }
      response_json = JSON.parse(response.body, symbolize_names: true)
      expect(response_json[:name]).to eq("altered name")
    end

    it 'return status 200 :ok' do
      contact = FactoryBot.create(:contact) 
      patch "/contacts/#{contact.id}", params: { "contact": { "name": "altered name" } }
      expect(response).to have_http_status(:ok)
    end

    it 'return status 404 :not_found' do
      contact = FactoryBot.create(:contact)
      patch "/contacts/#{contact.id + 1}", params: { "contact": { "name": "altered name" } }
      expect(response).to have_http_status(:not_found)
    end
  end

  #############################################################################
  describe 'PUT #update' do
    it 'rename a contact' do
      contact = FactoryBot.create(:contact)
      contact_params = {"contact": { "name": "altered name", "address": contact.address, "document": contact.document, "kind": contact.kind }}
      put "/contacts/#{contact.id}", params: contact_params
      response_json = JSON.parse(response.body, symbolize_names: true)
      expect(response_json[:name]).to eq("altered name")
    end

    it 'return status 200 :ok' do
      contact = FactoryBot.create(:contact) 
      contact_params = {"contact": { "name": "altered name", "address": contact.address, "document": contact.document, "kind": contact.kind }}
      put "/contacts/#{contact.id}", params: contact_params
      expect(response).to have_http_status(:ok)
    end

    it 'return status 404 :not_found' do
      contact = FactoryBot.create(:contact)
      contact_params = {"contact": { "name": "altered name", "address": contact.address, "document": contact.document, "kind": contact.kind }}
      put "/contacts/#{contact.id + 1}", params: contact_params
      expect(response).to have_http_status(:not_found)
    end
  end

  #############################################################################
  describe 'DELETE #destroy' do
    it 'delete a contact' do
      contact = FactoryBot.create(:contact)
      delete "/contacts/#{contact.id}"
      expect(response).to have_http_status(204)
    end

    it 'return status 204 :no_content' do
      contact = FactoryBot.create(:contact)
      delete "/contacts/#{contact.id}"
      expect(response).to have_http_status(:no_content)
    end

    it 'return status 404 :not_found' do
      contact = FactoryBot.create(:contact)
      delete "/contacts/#{contact.id + 1}"
      expect(response).to have_http_status(:not_found)
    end
  end

end
