# The first step of onboarding a user onto the GEMS program: language selection
# This operation also acts as the default entry point for all users in SDH, where
# the patient's number is stored and processed later in case they did not sign up completely

module Res
  module Gems
    class IvrLanguageSelection < Res::Gems::Base

      attr_accessor :exotel_params, :parsed_exotel_params, :res_user, :language_id,
                    :exophone, :state_id

      def initialize(logger, exotel_params)
        super(logger)
        self.exotel_params = exotel_params
      end


      def call

        # parse exotel params to get a simple hash with details like
        self.parsed_exotel_params = ExotelWebhook::ParseExotelParams.(self.exotel_params)

        # extract the language preference and state of the user
        self.language_id = Language.id_for(self.exotel_params[:language].to_s)
        self.logger.info("Language selected is: #{self.exotel_params[:language].to_s}")
        self.exophone = Exophone.find_by(virtual_number: self.parsed_exotel_params[:exophone])
        self.state_id = self.exophone.state_id

        # extract user from DB
        self.res_user = User.find_by mobile_number: self.parsed_exotel_params[:user_mobile]

        # if user doesn't exist, create them
        if self.res_user.blank?
          self.res_user = User.new(mobile_number: self.parsed_exotel_params[:user_mobile],
                                   incoming_call_date: Time.now,
                                   program_id: NooraProgram.id_for(:gems),
                                   language_preference_id: self.language_id,
                                   state_id: self.state_id)
          unless self.res_user.save
            self.errors = self.res_user.errors.full_messages
          end

          # also create an entry on the signup tracker which records details of a user's signup
          self.res_user.user_signup_trackers.build(noora_program_id: NooraProgram.id_for(:gems),
                                                   language_id: self.res_user.language_preference_id,
                                                   active: true).save
          self.logger.info("User created in DB with ID: #{self.res_user.id}")
        else
          self.res_user.update(language_preference_id: self.language_id,
                               program_id: NooraProgram.id_for(:gems),
                               incoming_call_date: Time.now,
                               state_id: self.state_id)

          # if the user is already part of another program, update that they have signed up for the GEMS program
          # If they are part of the GEMS program already, ignore this
          unless self.res_user.active_signups.where(noora_program_id: NooraProgram.id_for(:gems)).present?
            self.res_user.active_signups.update(active: false)
            self.res_user.user_signup_trackers.build(noora_program_id: NooraProgram.id_for(:gems),
                                                     language_id: self.res_user.language_preference_id,
                                                     active: true).save
          end

          self.logger.info("User found with mobile number: #{self.res_user.mobile_number}")
        end

        self
      end
    end
  end
end
