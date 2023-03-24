# this class handles signups through QR codes (and hence unique start-phrases)
# The parameters coming in are -
#
# mobile_number:
# state_name:
# program_name:
# qr_identifier:
# language_code:
#

module Res
  module Onboarding
    class QrSignup < Res::Onboarding::Base

      attr_accessor :qr_code, :qr_code_params, :program_id, :state_id, :qr_code_id, :language_id,
                    :qr_code, :res_user, :textit_group

      def initialize(logger, qr_code_params)
        super(logger)
        self.qr_code_params = qr_code_params
      end

      def call
        # first extract values for language, state etc from params
        self.program_id = NooraProgram.id_for(self.qr_code_params[:program_name])
        self.state_id = State.id_for(self.qr_code_params[:state_name])
        self.qr_code_id = QrCode.id_from_text_identifier(self.qr_code_params[:qr_identifier])
        self.qr_code = QrCode.find_by(id: self.qr_code_id)
        self.language_id = Language.with_code(self.qr_code_params[:language_code])&.id

        # first make sure all compulsory attributes are present
        if self.program_id.blank?
          self.errors << "Program name is blank or invalid"
          return self
        end

        if self.state_id.blank?
          self.errors << "State name is blank or invalid"
          return self
        end

        if self.qr_code_id.blank?
          self.errors << "Qr Code identifier is blank or invalid"
          return self
        end

        if self.language_id.blank?
          self.errors << "Default language is blank or invalid"
          return self
        end

        # now look for the user using their mobile number
        user_mobile = self.qr_code_params[:mobile_number]
        self.res_user = User.find_by mobile_number: user_mobile

        if self.res_user.present?
          # this is a case of the user already being part of a certain program
          # If the user is part of the same program and state, then just add an
          # entry in the signup tracker and move on
          # TODO - distinguish between signups across programs and states
          add_signup_tracker
          # if the user is already part of the same program and state, we don't need
          # to do anything. If not, we have to add them to the new textit group
          # # TODO - determine if the user needs to be updated here. Or if just recording the attempt is enough
          # return self
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
          language_preference_id: self.language_id,
          program_id: self.program_id,
          state_id: self.state_id,
          whatsapp_onboarding_date: DateTime.now
        )
      end


      def add_signup_tracker
        tracker = self.res_user.user_signup_trackers.build(
          noora_program_id: self.program_id,
          language_id: self.language_id,
          onboarding_method_id: OnboardingMethod.id_for(:qr_code),
          state_id: self.state_id,
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

      # this method adds a user to the relevant textit group using TextIt's APIs
      def create_user_with_relevant_group
        params = {id: self.res_user.id}
        params[:textit_group_id] = self.textit_group&.textit_id
        params[:logger] = self.logger
        # below line interacts with the API handler for TextIt and creates the user
        params[:fields] = {
          "date_joined" => self.res_user.whatsapp_onboarding_date,
          "onboarding_method" => "qr_code",
          "qr_code_id" => self.qr_code.name
        }

        op = TextitRapidproApi::CreateUser.(params)
        if op.errors.present?
          return false
        end
        true
      end


      # If a user is already on TextIt, the user is added to an existing group which is identified
      # from the TextitGroup class
      def add_user_to_existing_group
        params = {id: self.res_user.id, uuid: self.res_user.textit_uuid}
        params[:textit_group_id] = self.textit_group&.textit_id
        params[:logger] = self.logger
        params[:fields] = {
          "date_joined" => self.res_user.whatsapp_onboarding_date,
          "onboarding_method" => "qr_code",
          "qr_code_id" => self.qr_code.name
        }

        op = TextitRapidproApi::UpdateGroup.(params)
        if op.errors.present?
          return false
        end
        true
      end
    end
  end
end
