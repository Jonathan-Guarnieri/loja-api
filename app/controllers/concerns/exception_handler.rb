module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do |e|
      json({ message: e.message }, :not_found)
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      json({ message: e.message }, :unprocessable_entity)
    end

    # rescue_from ActionController::UnpermittedParameters do |e|
    #   json({ message: e.message }, :forbidden)
    # end

    # rescue_from Pundit::NotAuthorizedError do |e|
    #   json({ message: e.message }, :unauthorized)
    # end
  end
end
