require 'rails_helper'

RSpec.describe RegistrationsController, type: :request do
  context "sign-up" do
    context "valid registration" do
      it "successfully creates account" do

        params = {
          "name": "joão da silva",
          "role": "seller",
          "email": "jonathan@ruptiva.com",
          "password": "12345678",
          "password_confirmation": "12345678"
        }

        post "/auth", params: params

        expect(response.status).to eq(200)
      end
    end

    context "invalid registration" do
      context "missing information" do
        it "reports error with messages" do

          params = {
            "name": nil,
            "role": "seller",
            "email": "lucas@ruptiva.com",
            "password": "12345678"
          }

          post "/auth", params: params

          expect(response.body).to match(/Name can't be blank/)
        end
      end
    end
  end
end
