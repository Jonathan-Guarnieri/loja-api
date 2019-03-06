require 'rails_helper'
require 'support/auth_params_helper'

RSpec.describe OrdersController, type: :request do

  before(:each) do
    
    FactoryBot.create(:user)
    5.times do
      FactoryBot.create(:contact)
    end
  end

  #############################################################################
  describe 'GET #index' do
    it "return successfully all orders" do
      order_1 = FactoryBot.create(:order)
      order_2 = FactoryBot.create(:order)
      get '/orders', params: get_auth_params
      response_json = JSON.parse(response.body, symbolize_names: true)
      expect(response_json.size).to eq(2)
      expect(response_json[0][:id]).to eq(order_1.id)
      expect(response_json[1][:id]).to eq(order_2.id)
    end
    
    it 'return status 200 :ok' do
      get '/orders', params: get_auth_params
      expect(response).to have_http_status(:ok)
    end
  end

  #############################################################################
  describe 'POST #create' do
    it "Create order, verify attributes" do
      order = FactoryBot.build(:order)
      order_params = {"order": { "order_type": order.order_type, "contact_id": order.contact_id, 
              "user_id": order.user_id, "status": order.status }}
      post '/orders', params: order_params.merge(get_auth_params)
      response_json = JSON.parse(response.body, symbolize_names: true)
      expect(response_json[:order_type]).to eq(order.order_type)
      expect(response_json[:contact_id]).to eq(order.contact_id)
      expect(response_json[:user_id]).to eq(order.user_id)
      expect(response_json[:status]).to eq(order.status)
    end

    it 'return status 201 :created' do
      order = FactoryBot.build(:order)
      order_params = {"order": { "order_type": order.order_type, "contact_id": order.contact_id, 
              "user_id": order.user_id, "status": order.status }}
      post '/orders', params: order_params.merge(get_auth_params)
      expect(response).to have_http_status(:created)
    end
  end

  #############################################################################
  describe 'GET #show' do
    it 'return successfully a order' do
      order = FactoryBot.create(:order)
      get "/orders/#{order.id}", params: get_auth_params
      response_json = JSON.parse(response.body, symbolize_names: true)
      expect(response_json.size).to eq(8)
      expect(response_json[:id]).to eq(order.id)
      expect(response_json[:order_type]).to eq(order.order_type)
      expect(response_json[:contact_id]).to eq(order.contact_id)
      expect(response_json[:user_id]).to eq(order.user_id)
      expect(response_json[:status]).to eq(order.status)
    end

    it 'return status 200 :ok' do
      order = FactoryBot.create(:order)
      get "/orders/#{order.id}", params: get_auth_params
      expect(response).to have_http_status(:ok)
    end

    it 'return status 404 :not_found' do
      order = FactoryBot.create(:order)
      get "/orders/#{order.id + 1}", params: get_auth_params
      expect(response).to have_http_status(:not_found)
    end
  end

  #############################################################################
  describe 'PUT #update' do
    it 'reorder_type a order' do
      order = FactoryBot.create(:order)
      order_params = {"order": { "order_type": "altered order_type", "contact_id": order.contact_id, 
              "user_id": order.user_id, "status": order.status }}
      put "/orders/#{order.id}", params: order_params.merge(get_auth_params)
      response_json = JSON.parse(response.body, symbolize_names: true)
      expect(response_json[:order_type]).to eq("altered order_type")
    end

    it 'return status 200 :ok' do
      order = FactoryBot.create(:order) 
      order_params = {"order": { "order_type": "altered order_type", "contact_id": order.contact_id, 
              "user_id": order.user_id, "status": order.status }}
      put "/orders/#{order.id}", params: order_params.merge(get_auth_params)
      expect(response).to have_http_status(:ok)
    end

    it 'return status 404 :not_found' do
      order = FactoryBot.create(:order)
      order_params = {"order": { "order_type": "altered order_type", "contact_id": order.contact_id, 
              "user_id": order.user_id, "status": order.status }}
      put "/orders/#{order.id + 1}", params: order_params.merge(get_auth_params)
      expect(response).to have_http_status(:not_found)
    end
  end

  #############################################################################
  describe 'DELETE #destroy' do
    it 'delete a order' do
      order = FactoryBot.create(:order)
      delete "/orders/#{order.id}", params: get_auth_params
      expect(response).to have_http_status(204)
    end

    it 'return status 204 :no_content' do
      order = FactoryBot.create(:order)
      delete "/orders/#{order.id}", params: get_auth_params
      expect(response).to have_http_status(:no_content)
    end

    it 'return status 404 :not_found' do
      order = FactoryBot.create(:order)
      delete "/orders/#{order.id + 1}", params: get_auth_params
      expect(response).to have_http_status(:not_found)
    end
  end

end
