# require 'rails_helper'

# RSpec.describe V1::RegistrationsController, type: :request do
#   context "sign-up" do
#     context "valid registration" do
#       it "successfully creates account" do
#         allow_any_instance_of(Integrations::Zoop::Processor).to(
#            receive(:call!).and_return("new_seller_uid")
#         )

#         params = {
#           "name": "lucas",
#           "email": "lucas@ruptiva.com",
#           "password": "pwd:666",
#           "password_confirmation": "pwd:666",
#           "document": "01175631612",
#           "phone_number": "5531984793677"
#         }

#         post "/auth", params: params

#         expect(response.status).to eq(200)
#       end
#     end

#     context "invalid registration" do
#       context "missing information" do
#         it "reports error with messages" do
#           allow_any_instance_of(Integrations::Zoop::Processor).to(
#              receive(:call!).and_return("new_seller_uid")
#           )

#           params = {
#             "name": "lucas",
#             "email": "lucas@ruptiva.com",
#             "password": "pwd:666",
#             "password_confirmation": "pwd:666",
#             "phone_number": "5531984793677"
#           }

#           post "/v1/auth", params: params

#           expect(response.body).to match(/Document can't be blank/)
#         end
#       end
#     end
#   end
# end
