# this class deals with how a user is added to TextIt to onboard them on
# WhatsApp.
# ivr_params: Params received through the IVR method of onboarding
#

module Res
  module Onboarding
    class IvrInitialize < Res::Onboarding::Base

      attr_accessor :ivr_params, :parsed_exotel_params, :exophone, :res_user,
                    :textit_group

      def initialize(logger, ivr_params)
        super(logger)
        self.ivr_params = ivr_params
      end


      def call
        # first parse exotel parameters to extract relevant variables
        # An assumption here is that we are using Exotel as our provider, so we know
        # the format in which the parameters will be coming in
        self.parsed_exotel_params = ExotelWebhook::ParseExotelParams.(self.ivr_params)

        # next identify the Exophone so that we can localize it to a language, state etc.
        retrieve_exophone
        if self.exophone.blank?
          self.errors << "Exophone #{self.parsed_exotel_params[:exophone]} not found in database"
          return self
        end

        # at this step, the assumption is that the user has not signed up before
        # If they have, i.e. the user already exists, then create a signup tracker
        # with the relevant details of the mode of signup
        retrieve_user_from_ivr_params(self.parsed_exotel_params[:user_mobile])

        if self.res_user.present?
          # if the user already exists in the database, first check if they are already
          # onboarded with the same program, state and call

          if self.res_user.program_id == self.exophone.program_id &&
             self.res_user.state_id == self.exophone.state_id
            # do nothing, basically
            # add a signup tracker for this event and return
            add_signup_tracker
            return self
          else
            # i.e. the user is calling after signing up for another program in another state
            # In this case, update the user's attributes to the one specified by this exophone
            unless update_res_user
              return self
            end
          end
        else
          # i.e the user is calling for the first time. Pretty straightforward, just create the user
          # and then update the signup tracker for this particular call
          unless create_res_user
            return self
          end
        end

        # now add a signup tracker that logs this particular signup event
        unless add_signup_tracker
          return self
        end

        retrieve_textit_group
        return self if self.errors.present?

        # now create the user on TextIt with the relevant parameters
        unless create_user_with_relevant_group
          # resetting errors because we don't need them to carry over for the whole rest of the request
          self.errors = []

          # i.e. if the creation of a new user fails, try updating the user's group details
          add_user_to_existing_group
        end

        self
      end


      private

      def onboarding_method
        "ivr"
      end

      def create_res_user
        self.res_user = User.new(
          language_preference_id: self.exophone.language_id,
          program_id: self.exophone.program_id,
          state_id: self.exophone.state_id,
          incoming_call_date: DateTime.now,
          whatsapp_onboarding_date: DateTime.now,
          signed_up_to_whatsapp: true,
          mobile_number: self.parsed_exotel_params[:user_mobile]
        )

        unless self.res_user.save
          self.errors << self.res_user.errors.full_messages
          return false
        end
        true
      end

      def update_res_user
        unless self.res_user.update(
          language_preference_id: self.exophone.language_id,
          program_id: self.exophone.program_id,
          state_id: self.exophone.state_id,
          whatsapp_onboarding_date: DateTime.now,
          signed_up_to_whatsapp: true,
          incoming_call_date: DateTime.now # TODO - think about this
        )
          self.errors << self.res_user.errors.full_messages
          return false
        end
        true
      end

      def add_signup_tracker
        tracker = self.res_user.user_signup_trackers.build(
                      noora_program_id: self.exophone.program_id,
                      language_id: self.exophone.language_id,
                      onboarding_method_id: OnboardingMethod.id_for(:ivr),
                      state_id: self.exophone.state_id,
                      call_sid: self.parsed_exotel_params[:call_sid],
                      completed: false,
                      exophone_id: self.exophone.id
                      )
        unless tracker.save
          self.errors << tracker.errors.full_messages
          return false
        end
        true
      end

      def retrieve_textit_group
        self.textit_group = TextitGroup.where(program_id: self.exophone.program_id,
                                              language_id: self.exophone.language_id,
                                              state_id: self.exophone.state_id,
                                              onboarding_method_id: OnboardingMethod.id_for(:ivr)).first

        if self.textit_group.blank?
          self.errors << "Textit group not found for user with number: #{self.res_user.mobile_number}"
        end
      end

    end
  end
end