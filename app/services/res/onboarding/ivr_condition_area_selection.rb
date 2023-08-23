# this operation updates the condition area of a particular user and uses
# TestIt's APIs to update the user's preferences accordingly

module Res
  module Onboarding
    class IvrConditionAreaSelection < Res::Onboarding::Base

      attr_accessor :ivr_params, :parsed_exotel_params, :exophone, :res_user,
                    :condition_area_id, :textit_group

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

        # retrieve user from DB
        retrieve_user_from_ivr_params(self.parsed_exotel_params[:user_mobile])
        if self.res_user.blank?
          self.errors << "User not found in database with mobile number: #{self.parsed_exotel_params[:user_mobile]}"
          return self
        end

        # if the user has already signed up via RCH, just update the signup tracker
        # and move on
        if self.res_user.program_id == NooraProgram.id_for(:rch) &&
          self.res_user.state_id == self.exophone.state_id
          if self.res_user.signed_up_to_whatsapp?
            # i.e. if the user is already part of the RCH program, nothing changes
            # add a signup tracker for this event and move on
            add_signup_tracker
            return self
          else
            # in this case, the user is part of our DB, but has not opted into our service
            # We should be adding them to the RCH service in this scenario
            self.textit_group = TextitGroup.find_by(condition_area_id: ConditionArea.id_for(:anc),
                                                    program_id: NooraProgram.id_for(:rch),
                                                    state_id: self.res_user.state_id)
            # add the user to textit with their RCH data
            if create_user_with_relevant_group
              self.res_user.update(whatsapp_onboarding_date: DateTime.now, signed_up_to_whatsapp: true)
              add_signup_tracker
            end
            return self
          end
        end

        # now check if the user has completely onboarded themselves onto the service
        # if they have, just update tracker and don't do anything else
        if self.res_user.fully_onboarded_to_res?(self.exophone.program_id, self.exophone.state_id)
          update_signup_tracker
          return self
        end

        self.condition_area_id = ConditionArea.id_for(self.ivr_params[:condition_area])
        if self.condition_area_id.blank?
          self.errors << "Condition area not found in Database"
          return self
        end

        # add condition area mapping to the user
        self.res_user.add_condition_area(self.exophone.program_id, self.condition_area_id)

        # retrieve the correct TextIt group based on the information about the user
        retrieve_textit_group
        return self if self.errors.present?

        add_user_to_existing_group

        # update the signup tracker for the user
        update_signup_tracker

        self
      end


      private

      def onboarding_method
        "ivr"
      end

      def update_signup_tracker
        tracker = self.res_user.user_signup_trackers.find_by(call_sid: self.parsed_exotel_params[:call_sid])
        tracker&.update(condition_area_id: self.condition_area_id, completed: true, completed_at: DateTime.now)
      end


      def retrieve_textit_group
        self.textit_group = TextitGroup.where(program_id: self.exophone.program_id,
                                              language_id: self.exophone.language_id,
                                              state_id: self.exophone.state_id,
                                              condition_area_id: self.condition_area_id,
                                              onboarding_method_id: OnboardingMethod.id_for(:ivr)).first

        if self.textit_group.blank?
          self.errors << "Textit group not found for user with number: #{self.res_user.mobile_number}"
        end
      end

      def add_signup_tracker
        tracker = self.res_user.user_signup_trackers.build(
          noora_program_id: self.exophone.program_id,
          language_id: self.exophone.language_id,
          onboarding_method_id: OnboardingMethod.id_for(:ivr),
          state_id: self.exophone.state_id,
          call_sid: self.parsed_exotel_params[:call_sid],
          completed: true,
          exophone_id: self.exophone.id,
          event_timestamp: DateTime.now,
          call_direction: self.parsed_exotel_params[:direction]
        )
        unless tracker.save
          self.errors << tracker.errors.full_messages
          return false
        end
        true
      end

    end
  end
end
