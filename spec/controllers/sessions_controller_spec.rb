require 'rails_helper'

RSpec.describe SessionsController, type: :request do
  # let(:user) { FactoryBot.create(:user) }

  context "login" do
    context "valid user login" do
      it "generates access token" do
        user = FactoryBot.build(:user)
        post "/auth", params: {
          "name": user.name,
          "password": user.password,
          "password_confirmation": user.password,
          "role": user.role,
          "email": user.email
        }
        params = {
          "email": user.email,
          "password": user.password
        }
        post "/auth/sign_in", params: params
        expect(response.headers).to include("access-token")
        expect(response.headers).to include("client")
        expect(response.headers).to include("expiry")
        expect(response.headers).to include("uid")
        expect(response.headers.fetch("token-type")).to eq("Bearer")
      end

      it "grants access to resources" do
        user = FactoryBot.create(:user)
        params = {
          "email": user.email,
          "password": user.password
        }

        post "/auth/sign_in", params: params

        headers = {
          "access-token": response.headers.fetch("access-token"),
          "uid": response.headers.fetch("uid"),
          "token-type": response.headers.fetch("token-type"),
          "client": response.headers.fetch("client")
        }

        get "/auth/validate_token", headers: headers

        expect(response.status).to eq(200)
      end
    end

    context "invalid user email" do
      it "doesnt generates access token" do
        user = FactoryBot.create(:user)
        params = {
          "email": user.email,
          "password": user.password + "nope"
        }

        post "/auth/sign_in", params: params

        expect(response.headers).not_to include("access-token")
        expect(response.headers).not_to include("client")
        expect(response.headers).not_to include("expiry")
        expect(response.headers).not_to include("uid")
        expect(response.headers).not_to include("token-type")
      end

      it "denies access to resources" do
        headers = {
          "access-token": "access-token",
          "uid": "uid",
          "token-type": "token-type",
          "client": "client"
        }

        get "/auth/validate_token", headers: headers

        expect(response.status).to eq(401)
      end
    end
  end

  context "logout" do
    it "valid credentials" do
      user = FactoryBot.create(:user)
      params = {
        "email": user.email,
        "password": user.password
      }

      post "/auth/sign_in", params: params

      headers = {
        "access-token": response.headers.fetch("access-token"),
        "uid": response.headers.fetch("uid"),
        "token-type": response.headers.fetch("token-type"),
        "client": response.headers.fetch("client")
      }

      delete "/auth/sign_out", headers: headers

      expect(response.status).to eq(200)
    end

    xit "invalid credentials" do
      headers = {
        "access-token": "access-token",
        "uid": "uid",
        "token-type": "token-type",
        "client": "client"
      }

      delete "/auth/sign_out", headers: headers

      expect(response.status).to eq(401)
    end
  end
end
