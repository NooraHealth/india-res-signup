class ApplicationController < ActionController::Base
  include Errors

  around_action :handle_errors

  def handle_errors
    begin
      yield
    rescue ::ActionController::ParameterMissing => error
      render status: 400, json: {
               error: "Missing parameter: '#{error.param}'",
               code: "PARAM_MISSING",
             }
    rescue ErrorResponse => error
      render status: error.status, json: error.data
    end
  end

end
