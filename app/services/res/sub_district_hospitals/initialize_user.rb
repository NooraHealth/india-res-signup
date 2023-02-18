# this method creates the user in our Database as soon as a user calls
# So irrespective of the user selecting any option within the IVR, the user is
# added to our DB so that we can follow up with them even if they didn't fully sign up

########### NOT BEING USED AT THE MOMENT ##############

module Res
  module SubDistrictHospitals
    class InitializeUser < Res::SubDistrictHospitals::Base

      attr_accessor :exotel_params, :res_user, :parsed_exotel_params, :exophone

      def initialize(logger)
        super(logger)
        self.exotel_params = exotel_params
      end

      def call
        # parse exotel params to get a simple hash with details like exophone. user mobile number etc.
        self.parsed_exotel_params = ExotelWebhook::ParseExotelParams.(self.exotel_params)
        self.exophone = Exophone.find_by virtual_number: self.parsed_exotel_params[:exophone]

        # since the user doesn't exist at all, create the user with the bare minimum that we know about
        # the user - which is the state and the program details
        # if the user already exists, then don't do anything
        self.res_user = User.find_by mobile_number: self.parsed_exotel_params[:user_mobile]

        if self.res_user.blank?
          self.res_user = User.new(mobile_number: self.parsed_exotel_params[:user_mobile],
                                   program_id: NooraProgram.id_for(:sdh),
                                   state_id: self.exophone&.state_id)
          unless res_user.save
            self.errors << self.res_user.errors.full_messages
            return self
          end
        end

        self
      end


    end
  end
end