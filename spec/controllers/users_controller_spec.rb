require 'rails_helper'

RSpec.describe UsersController, type: :request do

  #############################################################################
  describe 'GET #index' do
    it "return successfully all users" do
      user_1 = FactoryBot.create(:user)
      user_2 = FactoryBot.create(:user)
      get '/users'
      response_json = JSON.parse(response.body, symbolize_names: true)
      expect(response_json.size).to eq(2)
      expect(response_json[0][:id]).to eq(user_1.id)
      expect(response_json[1][:name]).to eq(user_2.name)
    end
    
    it 'return status 200 :ok' do
      get '/users'
      expect(response).to have_http_status(:ok)
    end
  end

  #############################################################################
  describe 'POST #create' do
    it "Create user, verify attributes" do
      user = FactoryBot.build(:user)
      user_params = {"user": { "name": user.name, "role": user.role, "login": user.login, "password": user.password }}
      post '/users', params: user_params
      response_json = JSON.parse(response.body, symbolize_names: true)
      expect(response_json[:name]).to eq(user.name)
      expect(response_json[:role]).to eq(user.role)
      expect(response_json[:login]).to eq(user.login)
      expect(response_json[:password]).to eq(user.password)
    end

    it 'return status 201 :created' do
      user = FactoryBot.build(:user)
      user_params = {"user": { "name": user.name, "role": user.role, "login": user.login, "password": user.password }}
      post '/users', params: user_params
      expect(response).to have_http_status(:created)
    end
  end

  #############################################################################
  describe 'GET #show' do
    it 'return successfully a user' do
      user = FactoryBot.create(:user)
      get "/users/#{user.id}"
      response_json = JSON.parse(response.body, symbolize_names: true)
      expect(response_json.size).to eq(7)
      expect(response_json[:id]).to eq(user.id)
      expect(response_json[:name]).to eq(user.name)
      expect(response_json[:role]).to eq(user.role)
      expect(response_json[:login]).to eq(user.login)
      expect(response_json[:password]).to eq(user.password)
    end

    it 'return status 200 :ok' do
      user = FactoryBot.create(:user)
      get "/users/#{user.id}"
      expect(response).to have_http_status(:ok)
    end

    it 'return status 404 :not_found' do
      user = FactoryBot.create(:user)
      get "/users/#{user.id + 1}"
      expect(response).to have_http_status(:not_found)
    end
  end

  #############################################################################
  describe 'PATCH #update' do ### daqui em diante
    it 'rename a user' do
      user = FactoryBot.create(:user) 
      patch "/users/#{user.id}", params: { "user": { "name": "altered name" } }
      response_json = JSON.parse(response.body, symbolize_names: true)
      expect(response_json[:name]).to eq("altered name")
    end

    it 'return status 200 :ok' do
      user = FactoryBot.create(:user) 
      patch "/users/#{user.id}", params: { "user": { "name": "altered name" } }
      expect(response).to have_http_status(:ok)
    end

    it 'return status 404 :not_found' do
      user = FactoryBot.create(:user)
      patch "/users/#{user.id + 1}", params: { "user": { "name": "altered name" } }
      expect(response).to have_http_status(:not_found)
    end
  end

  #############################################################################
  describe 'PUT #update' do
    it 'rename a user' do
      user = FactoryBot.create(:user)
      user_params = {"user": { "name": "altered name", "role": user.role, "login": user.login, "password": user.password }}
      put "/users/#{user.id}", params: user_params
      response_json = JSON.parse(response.body, symbolize_names: true)
      expect(response_json[:name]).to eq("altered name")
    end

    it 'return status 200 :ok' do
      user = FactoryBot.create(:user) 
      user_params = {"user": { "name": "altered name", "role": user.role, "login": user.login, "password": user.password }}
      put "/users/#{user.id}", params: user_params
      expect(response).to have_http_status(:ok)
    end

    it 'return status 404 :not_found' do
      user = FactoryBot.create(:user)
      user_params = {"user": { "name": "altered name", "role": user.role, "login": user.login, "password": user.password }}
      put "/users/#{user.id + 1}", params: user_params
      expect(response).to have_http_status(:not_found)
    end
  end

  #############################################################################
  describe 'DELETE #destroy' do
    it 'delete a user' do
      user = FactoryBot.create(:user)
      delete "/users/#{user.id}"
      expect(response).to have_http_status(204)
    end

    it 'return status 204 :no_content' do
      user = FactoryBot.create(:user)
      delete "/users/#{user.id}"
      expect(response).to have_http_status(:no_content)
    end

    it 'return status 404 :not_found' do
      user = FactoryBot.create(:user)
      delete "/users/#{user.id + 1}"
      expect(response).to have_http_status(:not_found)
    end
  end

end
