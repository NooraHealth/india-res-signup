class ApplicationController < ActionController::Base
  include Errors

  around_action :handle_errors

  def handle_errors
    begin
      yield
    rescue ErrorResponse => error
      render status: error.status, json: error.data
    end
  end

end
