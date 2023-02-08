# this class will add a user onto TextIt using a webhook from Exotel. The number (exophone) from which
# the call is going out will tell us the condition area, program and state details that we are looking for
# The user essentially picks a language at this step and we will be using that as consent + language selection

module RchPortal
  class IvrSignup < RchPortal::Base

    attr_accessor :exotel_params, :parsed_params, :language_preference, :rch_user, :exophone, :textit_group

    def initialize(logger, params)
      super(logger)
      self.exotel_params = params
    end


    def call

      # first parse exotel parameters
      self.parsed_params = ExotelWebhook::ParseExotelParams.(self.exotel_params)

      self.language_preference = Language.find_by(iso_code: self.exotel_params[:language])
      if self.language_preference.blank?
        self.errors << "Language not found for user with mobile number: #{self.parsed_params[:user_mobile]}"
        return self
      end


      # find the exophone from which the call is coming in, so that we can figure out the condition areas, program etc.
      self.exophone  = Exophone.find_by(virtual_number: self.parsed_params[:exophone])
      if self.exophone.blank?
        self.errors << "No exophone found for this call from number: #{self.parsed_params[:exophone]}"
        return self
      end

      # the user has to be an existing one, because we are only looking at users who are already
      # onboarded onto our backend as part of the RCH program
      self.rch_user = User.find_by mobile_number: self.parsed_params[:user_mobile]
      if self.rch_user.blank?
        # i.e. this is a user randomly calling our number even though we haven't received their data through RCH
        self.errors << "User not found in DB for mobile number: #{self.parsed_params[:user_mobile]}"
        return self
      end

      # update the user's language preference to the appropriate one chosen by the user
      self.rch_user.update(language_preference_id: self.language_preference.id)

      self.textit_group = TextitGroup.find_by(condition_area_id: self.rch_user.condition_areas.first.id,
                                              program_id: self.exophone.program_id,
                                              state_id: self.exophone.state_id)

      if self.textit_group.blank?
        self.errors << "TextIt group not found for call of user #{self.rch_user.mobile_number} from #{self.exophone.virtual_number}"
        return self
      end

      # if user already exists on TextIt, then change their group
      if check_user_on_textit(self.rch_user)
        add_user_to_existing_group(self.rch_user, self.textit_group)
      else
        create_user_with_relevant_group(self.rch_user, self.textit_group)
      end

      self.rch_user.update(signed_up_to_whatsapp: true)

      self
    end

  end
end
