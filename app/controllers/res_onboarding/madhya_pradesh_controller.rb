module ResOnboarding
  class MadhyaPradeshController < ResOnboarding::Base

    # this endpoint orchestrates the missed call based onboarding mechanism that we have
    # in Maharashtra at the moment.
    def ccp_dh_signup
      op = Res::DistrictHospitals::ExotelWaSignup.(logger, exotel_params)
      if op.errors.present?
        logger.info("Operation returned error: #{op.errors.to_sentence}")
        render json: {success: false, errors: op.errors.to_sentence}
        return
      end
      # for now return 200 if the user is successfully onboarded
      render json: {success: true}
    end

    private

    private

    def exotel_params
      params.permit!
    end

    def initiate_logger
      self.logger = Logger.new("#{Rails.root}/log/madhya_pradesh/#{action_name}.log")
      self.logger.info("-------------------------------------")
      logger.info("API parameters are: #{params.permit!}")
    end

  end
end

