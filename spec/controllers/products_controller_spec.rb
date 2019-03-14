require 'rails_helper'
require 'support/auth_params_helper'

RSpec.describe ProductsController, type: :request do

  #############################################################################
  describe 'GET #index' do
    it "return successfully all products" do
      product_1 = FactoryBot.create(:product)
      product_2 = FactoryBot.create(:product)
      get '/products', params: get_auth_params
      response_json = JSON.parse(response.body, symbolize_names: true)
      expect(response_json.size).to eq(2)
      expect(response_json[0][:id]).to eq(product_1.id)
      expect(response_json[1][:id]).to eq(product_2.id)
    end
    
    it 'return status 200 :ok' do
      get '/products', params: get_auth_params
      expect(response).to have_http_status(:ok)
    end
  end

  #############################################################################
  describe 'POST #create' do
    it "Create product, verify attributes" do
      product = FactoryBot.build(:product)
      product_params = {"product": product.as_json}
      post '/products', params: product_params.merge(get_auth_params)
      response_json = JSON.parse(response.body, symbolize_names: true)
      expect(response_json[:name]).to eq(product.name)
      expect(response_json[:purchase_price]).to eq(product.purchase_price)
      expect(response_json[:sale_price]).to eq(product.sale_price)
      expect(response_json[:amount]).to eq(product.amount)
    end

    it 'return status 201 :created' do
      product = FactoryBot.build(:product)
      product_params = {"product": product.as_json}
      post '/products', params: product_params.merge(get_auth_params)
      expect(response).to have_http_status(:created)
    end
  end

  #############################################################################
  describe 'GET #show' do
    it 'return successfully a product' do
      product = FactoryBot.create(:product)
      get "/products/#{product.id}", params: get_auth_params
      response_json = JSON.parse(response.body, symbolize_names: true)
      expect(response_json.size).to eq(7)
      expect(response_json[:id]).to eq(product.id)
      expect(response_json[:name]).to eq(product.name)
      expect(response_json[:purchase_price]).to eq(product.purchase_price)
      expect(response_json[:sale_price]).to eq(product.sale_price)
      expect(response_json[:amount]).to eq(product.amount)
    end

    it 'return status 200 :ok' do
      product = FactoryBot.create(:product)
      get "/products/#{product.id}", params: get_auth_params
      expect(response).to have_http_status(:ok)
    end

    it 'return status 404 :not_found' do
      product = FactoryBot.create(:product)
      get "/products/#{product.id + 1}", params: get_auth_params
      expect(response).to have_http_status(:not_found)
    end
  end

  #############################################################################
  describe 'PUT #update' do
    it 'rename a product' do
      product = FactoryBot.create(:product)
      product.name = "altered name"
      product_params = {"product": product.as_json}
      put "/products/#{product.id}", params: product_params.merge(get_auth_params)
      response_json = JSON.parse(response.body, symbolize_names: true)
      expect(response_json[:name]).to eq("altered name")
    end

    it 'return status 200 :ok' do
      product = FactoryBot.create(:product) 
      product.name = "altered name"
      product_params = {"product": product.as_json}
      put "/products/#{product.id}", params: product_params.merge(get_auth_params)
      expect(response).to have_http_status(:ok)
    end

    it 'return status 404 :not_found' do
      product = FactoryBot.create(:product)
      product.name = "altered name"
      product_params = {"product": product.as_json}
      put "/products/#{product.id + 1}", params: product_params.merge(get_auth_params)
      expect(response).to have_http_status(:not_found)
    end
  end

  #############################################################################
  describe 'DELETE #destroy' do
    it 'delete a product' do
      product = FactoryBot.create(:product, amount: 0)
      delete "/products/#{product.id}", params: get_auth_params
      expect(response).to have_http_status(204)
    end

    it 'return status 204 :no_content' do
      product = FactoryBot.create(:product, amount: 0)
      delete "/products/#{product.id}", params: get_auth_params
      expect(response).to have_http_status(:no_content)
    end

    it 'return status 404 :not_found' do
      product = FactoryBot.create(:product, amount: 0)
      delete "/products/#{product.id + 1}", params: get_auth_params
      expect(response).to have_http_status(:not_found)
    end

    it 'denies delete for seller' do
      product = FactoryBot.create(:product, amount: 0)
      expect{ delete "/products/#{product.id}", params: get_auth_params("seller") 
      }.to raise_error(Pundit::NotAuthorizedError)
    end

    it 'denies delete for product with order' do
      product = FactoryBot.create(:product, amount: 0)
      order_item = FactoryBot.build(:order_item, product_id: product.id)
      order_params = FactoryBot.create(:order, order_item_attributes: order_item.as_json)
      expect{ delete "/products/#{product.id}", params: get_auth_params
      }.to raise_error(/is still referenced from table "order_items"/)
    end

    it 'denies delete for amount different by zero' do
      product = FactoryBot.create(:product, amount: 1)
      expect{ delete "/products/#{product.id}", params: get_auth_params
      }.to raise_error("it`s not possible delete products with amount")
    end
  end

end
