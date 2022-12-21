# this class will unsubscribe the user from the GEMS IVR

module Res
  module Gems
    class UnsubscribeIvr < Res::Gems::Base

      attr_accessor :exotel_params, :res_user, :parsed_exotel_params

      def initialize(logger, exotel_params)
        super(logger)
        self.exotel_params = exotel_params
      end

      def call
        # parse exotel params to get a simple hash with details like
        self.parsed_exotel_params = ExotelWebhook::ParseExotelParams.(self.exotel_params)

        self.res_user = User.find_by mobile_number: self.parsed_exotel_params[:user_mobile]

        unless self.res_user.update(subscribed_to_ivr: false,
                                    ivr_unsubscribe_date: DateTime.now)
          self.errors = self.res_user.errors.full_messages
        end

        self
      end
    end
  end
end
