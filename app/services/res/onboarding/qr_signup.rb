module Res
  module Onboarding
    class QrSignup < Res::Onboarding::Base

      attr_accessor :qr_code, :qr_code_params, :program_id, :state_id, :qr_code_id

      def initialize(logger, qr_code_params)
        super(logger)
        self.qr_code_params = qr_code_params
      end

      def call
        # first look for the user in our database
        user_mobile = self.qr_code_params[:mobile_number]
        self.res_user = User.find_by mobile_number: user_mobile

        self.program_id = NooraProgram.id_for(self.qr_code_params[:program])
        self.state_id = State.id_for(self.qr_code_params[:state])
        self.qr_code_id = QrCode.id_from_text_identifier(self.qr_code_params[:qr_identifier])
        self.language_id = Language.with_code(self.qr_code_params[:language_code])

        if self.res_user.present?
          # this is a case of the user already being part of a certain program
          # If the user is part of the same program and state, then just add an
          # entry in the signup tracker and move on
          add_signup_tracker
          # if the user is already part of the same program and state, we don't need
          # to do anything. If not, we have to add them to the new textit group
        else
          # i.e. the user doesn't already exist in the database
          create_res_user
          add_signup_tracker
        end

        # retrieve the relevant textit group
        retrieve_textit_group
        return self if self.errors.present?

        # now create the user on TextIt with the relevant parameters
        unless create_user_with_relevant_group
          # i.e. if the creation of a new user fails, try updating the user's group details
          add_user_to_existing_group
        end

        self
      end


      private


      def create_res_user
        self.res_user = User.new(
          language_preference_id: self.language_id,
          program_id: self.program_id,
          state_id: self.state_id,
          whatsapp_onboarding_date: DateTime.now,
          mobile_number: self.qr_code_params[:mobile_number]
        )

        unless self.res_user.save
          self.errors << self.res_user.errors.full_messages
          return false
        end
      end


      def update_res_user
        self.res_user.update(
          language_preference_id: self.exophone.language_id,
          program_id: self.exophone.program_id,
          state_id: self.exophone.state_id,
          whatsapp_onboarding_date: DateTime.now,
          incoming_call_date: DateTime.now # TODO - think about this
        )
      end


      def add_signup_tracker
        tracker = self.res_user.user_signup_trackers.build(
          noora_program_id: self.program_id,
          language_id: self.language_id,
          onboarding_method_id: OnboardingMethod.id_for(:qr_code),
          state_id: self.exophone.state_id,
          qr_code_id: self.qr_code_id,
          completed: true
        )

        unless tracker.save
          self.errors << tracker.errors.full_messages
          return false
        end
      end


      def retrieve_textit_group
        self.textit_group = TextitGroup.where(program_id: self.program_id,
                                              language_id: self.language_id,
                                              state_id: self.state_id,
                                              onboarding_method_id: OnboardingMethod.id_for(:qr_code)).first

        if self.textit_group.blank?
          self.errors << "Textit group not found for user with number: #{self.res_user.mobile_number}"
        end
      end

    end
  end
end
