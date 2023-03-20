# this will be the base class for our generalized onboarding process for RES going forward.
# The steps involved are:
# 1. User is onboarded onto WA as soon as they call
# 2. If user answers further questions their properties are duly updated by us step-by-step
# 3. If not, the user is asked the relevant questions on WA, post which they are acknowledged at our end

module Res
  module Onboarding
    class Base < ApplicationService

      attr_accessor :logger, :errors, :parsed_exotel_params

      def initialize(logger)
        self.logger = logger
        self.errors = []
      end


      protected

      def retrieve_exophone
        self.exophone = Exophone.find_by virtual_number: self.parsed_exotel_params[:exophone]
      end


      def retrieve_user_from_ivr_params(mobile_number)
        self.res_user = User.find_by(mobile_number: mobile_number)
        if self.res_user.present?
          self.logger.info("SUCCESSFULLY FOUND user in DATABASE with number #{self.res_user.mobile_number}")
        end
      end

    end
  end
end
