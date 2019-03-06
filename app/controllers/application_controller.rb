class ApplicationController < ActionController::API

  include DeviseTokenAuth::Concerns::SetUserByToken

  # app/controllers/concerns/ (exception_handler.rb and response.rb):
  # return errors in json format
  include Response
  include ExceptionHandler

  include Pundit
  # only for development:
  # after_action :verify_authorized, except: [:index, :create]   (Y)
  # after_action :verify_policy_scoped, only: :index             ???

  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(
      :sign_up,
      keys: [:name, :role, :email, :password] # ver quais precisa
    )
  end

end
