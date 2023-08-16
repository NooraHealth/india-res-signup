# this class will add a user onto TextIt using a webhook from Exotel. The number (exophone) from which
# the call is going out will tell us the condition area, program and state details that we are looking for
# The user essentially picks a language at this step and we will be using that as consent + language selection
# Params are basically same as Exotel's WA params along with one parameter that signifies language:
# pan - Punjabi
# hin - Hindi
# tel - Telugu

module RchPortal
  class IvrSignup < RchPortal::Base

    attr_accessor :exotel_params, :parsed_params, :language_preference, :rch_user, :exophone, :textit_group,
                  :condition_area_id

    def initialize(logger, params)
      super(logger)
      self.exotel_params = params
    end


    def call

      # first parse exotel parameters
      self.parsed_params = ExotelWebhook::ParseExotelParams.(self.exotel_params)

      # extract language details from params
      self.language_preference = Language.find_by(iso_code: self.exotel_params[:language])
      if self.language_preference.blank?
        self.errors << "Language not found for call from mobile number: #{self.parsed_params[:user_mobile]}"
        return self
      end


      # find the exophone from which the call is coming in, so that we can figure out the condition areas, program etc.
      self.exophone  = Exophone.find_by(virtual_number: self.parsed_params[:exophone])
      if self.exophone.blank?
        self.errors << "No exophone found for call from number: #{self.parsed_params[:exophone]}"
        return self
      end

      # the user has to be an existing one, because we are only looking at users who are already
      # added to our backend as part of the RCH program
      self.rch_user = User.find_by mobile_number: self.parsed_params[:user_mobile]
      if self.rch_user.blank?
        # i.e. this is a user randomly calling our number even though we haven't received their data through RCH
        self.errors << "User not found in DB for mobile number: #{self.parsed_params[:user_mobile]}"
        return self
      end

      # if the user is not part of the RCH program, then also raise an error message and log it
      if self.rch_user.program_id != NooraProgram.id_for(:rch)
        self.errors << "User with mobile number #{self.rch_user.mobile_number} is not part of the RCH program"
        return self
      end

      # # if the user is already onboarded onto WA and is part of the RCH program, ignore the request to onboard them again
      # if self.rch_user.signed_up_to_whatsapp && self.rch_user.program_id == NooraProgram.id_for(:rch)
      #   self.errors << "User with number #{self.turn_params[:mobile_number]} is already signed up to WhatsApp"
      #   return self
      # end

      # update the user's language preference to the appropriate one chosen by the user
      self.rch_user.update(language_preference_id: self.language_preference.id)

      self.condition_area_id = self.rch_user.user_condition_area_mappings.with_program_id(self.rch_user.program_id).first&.condition_area_id
      self.textit_group = TextitGroup.find_by(condition_area_id: self.condition_area_id,
                                              program_id: self.exophone.program_id,
                                              state_id: self.exophone.state_id)

      if self.textit_group.blank?
        self.errors << "TextIt group not found for call of user with number #{self.rch_user.mobile_number} from exophone #{self.exophone.virtual_number}"
        return self
      end

      # add the custom fields as a hash so that it can be added to a user's profile
      cf_params = {
        "name" => self.rch_user.name,
        "date_joined" => DateTime.now,
        "expected_date_of_delivery" => self.rch_user.expected_date_of_delivery,
        "onboarding_method" => "ivr"
      }

      unless create_user_with_relevant_group(self.rch_user, self.textit_group, cf_params)
        # resetting errors because we don't need them to carry over for the whole rest of the request
        self.errors = []
        add_user_to_existing_group(self.rch_user, self.textit_group, cf_params)
      end

      # if there are issues with signing on the user don't update the user as signed up
      return self if self.errors.present?

      self.rch_user.update(signed_up_to_whatsapp: true, whatsapp_onboarding_date: DateTime.now, onboarding_method_id: OnboardingMethod.id_for(:ivr))

      add_signup_tracker

      self
    end

    private

    def add_signup_tracker
      tracker = self.rch_user.user_signup_trackers.build(
        noora_program_id: self.exophone.program_id,
        language_id: self.exophone.language_id,
        onboarding_method_id: OnboardingMethod.id_for(:ivr),
        state_id: self.exophone.state_id,
        call_sid: self.parsed_params[:call_sid],
        completed: true,
        exophone_id: self.exophone.id,
        condition_area_id: self.condition_area_id,
        event_timestamp: DateTime.now,
        call_direction: self.parsed_params[:direction]
      )
      unless tracker.save
        self.errors << tracker.errors.full_messages
        return false
      end
      true
    end

  end
end
