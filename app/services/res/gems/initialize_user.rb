# this method creates the user in our Database as soon as a user calls
# So irrespective of the user selecting any option within the IVR, the user is
# added to our DB so that we can follow up with them even if they didn't fully sign up

# this operation is called from the check_existing_user endpoint where if the user doesn't exist they are created through this operation
module Res
  module Gems
    class InitializeUser < Res::Gems::Base

      attr_accessor :exotel_params, :res_user, :parsed_exotel_params

      def initialize(logger, exotel_params)
        super(logger)
        self.exotel_params = exotel_params
      end

      def call
        # parse exotel params to get a simple hash with details like
        self.parsed_exotel_params = ExotelWebhook::ParseExotelParams.(self.exotel_params)

        # since the user doesn't exist at all, create the user with the bare minimum that we know about
        # the user - which is the state and the program details
        # if the user already exists, then don't do anything
        self.res_user = User.find_by mobile_number: self.parsed_exotel_params[:user_mobile]

        if self.res_user.blank?
          self.res_user = User.new(mobile_number: self.parsed_exotel_params[:user_mobile],
                                   program_id: NooraProgram.id_for(:gems),
                                   state_id: State.id_for("Punjab"),
                                   incoming_call_date: DateTime.now)
          unless res_user.save
            self.errors << self.res_user.errors.full_messages
            return self
          end
        # elsif self.res_user.present?
        #   self.res_user.update(program_id: NooraProgram.id_for(:gems),
        #                        state_id: State.id_for("Punjab"),
        #                        incoming_call_date: DateTime.now)
        end

        self
      end
    end
  end
end