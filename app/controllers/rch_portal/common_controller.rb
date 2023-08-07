# this controller will be used for common functions that are not dependent on state per se
# In case there's a divergence in the way certain functions operate within a state,
# we can

module RchPortal
  class CommonController < ApplicationController

    attr_accessor :logger

    skip_forgery_protection

    before_action :initiate_logger

    def surveycto_wa_signup
      op = RchPortal::SignupFromSurveycto.(logger, params.permit!)
      @users_result = op.users_result
      render status: 200, template: 'rch_portal/common/surveycto_wa_signup'
    end

    private

    def initiate_logger
      self.logger = Logger.new("#{Rails.root}/log/rch/common/#{action_name}.log")
      self.logger.info("-------------------------------------")
      logger.info("API parameters are: #{params.permit!}")
    end


  end
end
