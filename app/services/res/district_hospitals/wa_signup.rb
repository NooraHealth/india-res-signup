module Res
  module DistrictHospitals

    class WaSignup < ApplicationService

      attr_accessor :exotel_params, :parsed_exotel_params, :res_user

      def initialize(exotel_params)
        self.exotel_params = exotel_params
      end

      def call
        self.message_logger = Logger.new("#{Rails.root}/log/aarogya_seva_text_it_api.log")

        # parse exotel params to get a simple hash with details like
        self.parsed_exotel_params = ExotelApi::ParseExotelParams.(self.exotel_params)

        # extract details of the user from parsed exotel parameters

      end
    end

    protected

    def retrieve_user
      self.exotel_user = User.find_by(mobile_number: self.parsed_details[:user_mobile])
      if self.exotel_user.present?
        self.message_logger.info("SUCCESSFULLY FOUND user in DATABASE with number #{self.exotel_user.mobile_number}")
      end
    end


  end
end