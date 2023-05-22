class ApplicationController < ActionController::Base
  include CustomErrors

  attr_accessor :logger

  protected

  def elog(error)
    dirname = "#{Rails.root}/log/errors/#{self.controller_name}"
    FileUtils.mkdir_p dirname

    logger = Logger.new("#{dirname}/#{action_name}.log")
    logger.warn(error)
  end

  def handle_errors
    begin
      yield
    # rescue ::ActionController::ParameterMissing => error
    #   message = "Missing parameter: '#{error.param}'"
    #   elog message
    #   render status: 400, json: {error: message, code: "PARAM_MISSING"}
    rescue ErrorResponse => error
      elog error.message
      render status: error.status, json: error.data
    end
  end
end
