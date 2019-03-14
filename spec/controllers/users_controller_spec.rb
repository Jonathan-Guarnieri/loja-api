require 'rails_helper'
require 'support/auth_params_helper'

RSpec.describe UsersController, type: :request do

  #############################################################################
  describe 'GET #index' do
    it "return successfully all users" do
      user_1 = FactoryBot.create(:user)
      user_2 = FactoryBot.create(:user)
      get '/users', params: get_auth_params
      response_json = JSON.parse(response.body, symbolize_names: true)
      expect(response_json.size).to eq(3)
      # User zero is create by auth_params_helper
      expect(response_json[1][:id]).to eq(user_1.id + 1)
      expect(response_json[2][:id]).to eq(user_2.id + 1)
    end
    
    it 'return status 200 :ok' do
      get '/users', params: get_auth_params
      expect(response).to have_http_status(:ok)
    end

    it 'denies index for seller' do
      2.times do; FactoryBot.create(:user); end
      expect{ get '/users', params: get_auth_params("seller") }.to raise_error(Pundit::NotAuthorizedError)
    end

    it 'denies index if user didn`t logged in' do
      2.times do; FactoryBot.create(:user); end
      get '/users'
      expect(response.body).to include("You need to sign in or sign up before continuing")
    end
  end

  #############################################################################
  describe 'POST #create' do
    it "Create user, verify attributes" do
      user = FactoryBot.build(:user)
      user_params = {"user": user.as_json}
      post '/users', params: user_params.merge(get_auth_params)
      response_json = JSON.parse(response.body, symbolize_names: true)
      expect(response_json[:name]).to eq(user.name)
      expect(response_json[:role]).to eq(user.role)
      expect(response_json[:email]).to eq(user.email)
    end

    it 'return status 201 :created' do
      user = FactoryBot.build(:user)
      user_params = {"user": user.as_json}
      post '/users', params: user_params.merge(get_auth_params)
      expect(response).to have_http_status(:created)
    end

    it 'denies post for seller' do
      user = FactoryBot.build(:user)
      user_params = {"user": user.as_json}
      expect{ post '/users', params: user_params.merge(get_auth_params("seller")) 
      }.to raise_error(Pundit::NotAuthorizedError)
    end

    it 'denies post if user didn`t logged in' do
      user = FactoryBot.build(:user)
      user_params = {"user": user.as_json}
      post '/users', params: user_params
      expect(response.body).to include("You need to sign in or sign up before continuing")
    end
  end

  #############################################################################
  describe 'GET #show' do
    it 'return successfully a user' do
      user = FactoryBot.create(:user)
      get "/users/#{user.id}", params: get_auth_params
      response_json = JSON.parse(response.body, symbolize_names: true)
      expect(response_json.size).to eq(9)
      expect(response_json[:id]).to eq(user.id)
      expect(response_json[:name]).to eq(user.name)
      expect(response_json[:role]).to eq(user.role)
      expect(response_json[:email]).to eq(user.email)
    end

    it 'return status 200 :ok' do
      user = FactoryBot.create(:user)
      get "/users/#{user.id}", params: get_auth_params
      expect(response).to have_http_status(:ok)
    end

    it 'return status 404 :not_found' do
      user = FactoryBot.create(:user)
      # User zero it`s create by auth_params_helper
      get "/users/#{user.id + 1 + 1}", params: get_auth_params
      expect(response).to have_http_status(:not_found)
    end

    it 'denies show for seller' do
      user = FactoryBot.create(:user)
      expect{ get "/users/#{user.id}", params: get_auth_params("seller") 
      }.to raise_error(Pundit::NotAuthorizedError)
    end

    it 'denies show if user didn`t logged in' do
      user = FactoryBot.create(:user)
      get "/users/#{user.id}"
      expect(response.body).to include("You need to sign in or sign up before continuing")
    end
  end

  #############################################################################
  describe 'PUT #update' do
    it 'rename a user' do
      user = FactoryBot.create(:user)
      user.name = "altered name"
      user_params = {"user": user.as_json}
      put "/users/#{user.id}", params: user_params.merge(get_auth_params)
      response_json = JSON.parse(response.body, symbolize_names: true)
      expect(response_json[:name]).to eq("altered name")
    end

    it 'return status 200 :ok' do
      user = FactoryBot.create(:user) 
      user.name = "altered name"
      user_params = {"user": user.as_json}
      put "/users/#{user.id}", params: user_params.merge(get_auth_params)
      expect(response).to have_http_status(:ok)
    end

    it 'return status 404 :not_found' do
      user = FactoryBot.create(:user)
      user.name = "altered name"
      user_params = {"user": user.as_json}
      # User zero it`s create by auth_params_helper
      put "/users/#{user.id + 1 + 1}", params: user_params.merge(get_auth_params)
      expect(response).to have_http_status(:not_found)
    end

    it 'denies put for seller' do
      user = FactoryBot.create(:user)
      user.name = "altered name"
      user_params = {"user": user.as_json}
      expect{ put "/users/#{user.id}", params: user_params.merge(get_auth_params("seller"))
      }.to raise_error(Pundit::NotAuthorizedError)
    end

    it 'denies put if user didn`t logged in' do
      user = FactoryBot.create(:user)
      user.name = "altered name"
      user_params = {"user": user.as_json}
      put "/users/#{user.id}", params: user_params
      expect(response.body).to include("You need to sign in or sign up before continuing")
    end
  end

  #############################################################################
  describe 'DELETE #destroy' do
    it 'delete a user' do
      user = FactoryBot.create(:user)
      delete "/users/#{user.id}", params: get_auth_params
      expect(response).to have_http_status(204)
    end

    it 'return status 204 :no_content' do
      user = FactoryBot.create(:user)
      delete "/users/#{user.id}", params: get_auth_params
      expect(response).to have_http_status(:no_content)
    end

    it 'return status 404 :not_found' do
      user = FactoryBot.create(:user)
      # User zero it`s create by auth_params_helper
      delete "/users/#{user.id + 1 + 1}", params: get_auth_params
      expect(response).to have_http_status(:not_found)
    end
    
    it 'denies delete if user has order' do
      user = FactoryBot.create(:user)
      FactoryBot.create(:order, user: user)
      expect{ delete "/users/#{user.id}", params: get_auth_params 
      }.to raise_error(/is still referenced from table "orders"/)
    end

    it 'denies delete for seller' do
      user = FactoryBot.create(:user)
      expect{ delete "/users/#{user.id}", params: get_auth_params("seller") 
      }.to raise_error(Pundit::NotAuthorizedError)
    end

    it 'denies delete if user didn`t logged in' do
      user = FactoryBot.create(:user)
      delete "/users/#{user.id}"
      expect(response.body).to include("You need to sign in or sign up before continuing")
    end
  end

end
