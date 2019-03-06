# module AuthParamsHelper

  # def login
  #   user = FactoryBot.create(:user)
  #   post "/auth/sign_in", 
  #         params:  { email: user.email, password: user.password }#, 
  #         # headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
  # end

  def get_auth_params
    user = FactoryBot.create(:user)
    post "/auth/sign_in", params: { email: user.email, password: user.password }
    
    client = response.headers['client']
    token = response.headers['access-token']
    expiry = response.headers['expiry']
    token_type = response.headers['token-type']
    uid = response.headers['uid']

    auth_params = {
      'access-token' => token,
      'client' => client,
      'uid' => uid,
      'expiry' => expiry,
      'token_type' => token_type
    }

    auth_params

  end

# end
