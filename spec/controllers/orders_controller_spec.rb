require 'rails_helper'
require 'support/auth_params_helper'

RSpec.describe OrdersController, type: :request do

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
      order_params = {"order": order.as_json }

      post '/orders', params: order_params.merge(get_auth_params)
      response_json = JSON.parse(response.body, symbolize_names: true)

      expect(response_json[:order_type]).to eq(order.order_type)
      expect(response_json[:contact_id]).to eq(order.contact_id)
      # order_id no FactoryBot.build é 1 a menos que na response do post, por isso soma 1
      expect(response_json[:user_id]).to eq(order.user_id + 1)
      expect(response_json[:status]).to eq(order.status)
    end

    it "Create order with nested item" do
      FactoryBot.create(:product)
      order = FactoryBot.build(:order)
      order_item = FactoryBot.build(:order_item)
      order_with_item_params ={ "order": order.as_json.merge({"order_item_attributes": [order_item.as_json]})}

      post '/orders', params: order_with_item_params.merge(get_auth_params)

      response_json = JSON.parse(response.body, symbolize_names: true)

      response_json.as_json(except: [:id, :user_id, :created_at, :updated_at, :order_item]).each do |key, value|
        expect(value).to eq(order[key.to_sym])
      end

      response_json[:order_item][0].as_json(except: [:id, :created_at, :updated_at, :order_id]).each do |key, value|
        # order_id no FactoryBot.build é 1 a menos que na response do post, por isso não está sendo testado
        expect(value).to eq(order_item[key.to_sym])
      end
    end

    it 'return status 201 :created' do
      order = FactoryBot.build(:order)
      order_params = {"order": order.as_json}
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
    it 'change status of an order' do
      order = FactoryBot.create(:order)
      order_params = {"order": order.as_json(except: :status).merge("status": "canceled") }      
      put "/orders/#{order.id}", params: order_params.merge(get_auth_params)
      response_json = JSON.parse(response.body, symbolize_names: true)
      expect(response_json[:status]).to eq("canceled")
    end

    it 'return status 200 :ok' do
      order = FactoryBot.create(:order) 
      order_params = {"order": order.as_json(except: :status).merge("status": "canceled") }
      put "/orders/#{order.id}", params: order_params.merge(get_auth_params)
      expect(response).to have_http_status(:ok)
    end
  end

  #############################################################################
  describe 'DELETE #destroy' do
    it 'delete a order' do
      order = FactoryBot.create(:order, status: "canceled")
      delete "/orders/#{order.id}", params: get_auth_params
      expect(response).to have_http_status(204)
    end

    it 'return status 204 :no_content' do
      order = FactoryBot.create(:order, status: "canceled")
      delete "/orders/#{order.id}", params: get_auth_params
      expect(response).to have_http_status(:no_content)
    end

    it 'denies delete for seller' do
      order = FactoryBot.create(:order, status: "canceled")
      expect{ delete "/orders/#{order.id}", params: get_auth_params("seller") 
      }.to raise_error(Pundit::NotAuthorizedError)
    end

    it 'denies delete if status is not canceled' do
      order = FactoryBot.create(:order, status: "production")
      expect{ delete "/orders/#{order.id}", params: get_auth_params 
      }.to raise_error("Order can only be deleted if it has the canceled status")
    end
  end

end
