class RegistrationsController < DeviseTokenAuth::RegistrationsController

  skip_before_action :authenticate_user!
  
  # protected

  # def build_resource
  #   @resource            = resource_class.new(sign_up_params)
  #   @resource.provider   = provider

  #   # honor devise configuration for case_insensitive_keys
  #   if resource_class.case_insensitive_keys.include?(:email)
  #     @resource.email = sign_up_params[:email].try(:downcase)
  #   else
  #     @resource.email = sign_up_params[:email]
  #   end
  # end

end