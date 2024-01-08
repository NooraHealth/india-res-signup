# frozen_string_literal: true

module TbRes
  class WhatsappSignupFromIvr < TbRes::Base

    attr_accessor :ivr_params, :tb_user, :parsed_ivr_params

    def initialize(logger, params)
      super(logger)
      self.ivr_params = params
    end

    def call
      self.parsed_ivr_params = ExotelWebhook::ParseExotelParams.(ivr_params)

      # first check if the user exists in our database
      self.tb_user = User.find_by mobile_number: parsed_ivr_params[:user_mobile]

      if self.tb_user.blank?
        self.errors << "User with mobile number: #{parsed_ivr_params[:user_mobile]} not found in database"
        return self
      end

      # if the user is actually present in the DB, then call the Textit APIs to
      # update the user's group to the relevant one on TB-RES
      # Steps to achieve this:
      # 1. Retrieve the textit group of the user
      # 2. Call the Textit API to update the user's group to the relevant one
      # 3. Update the user's signed_up_to_whatsapp to true, along with the respective timestamp
      # 4. Update the user's textit_uuid to the one received in the webhook

      # 1. Retrieve the textit group of the user
      textit_group = TextitGroup.find_by program_id: NooraProgram.id_for(:tb_res),
                                         language_id: user.language_preference_id,
                                         state_id: user.state_id

      if textit_group.blank?
        self.errors << "Textit group not found for program: TB-RES, language: #{user.language_preference_id}, state: #{user.state_id}"
        return self
      end

      # 2. Call the Textit API to update the user's group to the relevant one
      unless add_user_to_existing_group
        self.errors << "Could not add user to existing group because: #{self.errors.to_sentence}"
        return self
      end

      # 3. Update the user's signed_up_to_whatsapp to true, along with the respective timestamp
      self.tb_user.update(signed_up_to_whatsapp: true, whatsapp_onboarding_date: DateTime.now)

    end
  end
end

