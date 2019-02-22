class ApplicationController < ActionController::API
  # app/controllers/concerns/ (exception_handler.rb and response.rb):
  # return errors in json format
  include Response
  include ExceptionHandler 
end
