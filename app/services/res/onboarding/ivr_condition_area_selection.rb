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

        self
      end


      private

      def onboarding_method
        "ivr"
      end

      def update_signup_tracker
        tracker = self.res_user.user_signup_trackers.find_by(call_sid: self.parsed_exotel_params[:call_sid])
        tracker&.update(condition_area_id: self.condition_area_id, completed: true)
      end


      def retrieve_textit_group
        self.textit_group = TextitGroup.where(program_id: self.exophone.program_id,
                                              language_id: self.exophone.language_id,
                                              state_id: self.exophone.state_id,
                                              condition_area_id: self.condition_area_id).first

        if self.textit_group.blank?
          self.errors << "Textit group not found for user with number: #{self.res_user.mobile_number}"
        end
      end

    end
  end
end
