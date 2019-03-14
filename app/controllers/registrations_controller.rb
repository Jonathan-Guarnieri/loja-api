class RegistrationsController < DeviseTokenAuth::RegistrationsController
  skip_before_action :authenticate_user!
end
