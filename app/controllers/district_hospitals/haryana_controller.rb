module DistrictHospitals
  class HaryanaController < ApplicationController

    attr_accessor :logger

    before_action :initiate_logger

    def ivr_initialize_user

    end

    def ivr_select_condition_area

    end

    def qr_signup

    end

    private

    def exotel_params
      params.permit!
    end

    def initiate_logger
      self.logger = Logger.new("#{Rails.root}/log/hp/#{action_name}.log")
      self.logger.info("-------------------------------------")
      logger.info("API parameters are: #{hp_dh_params}")
    end
  end
end
