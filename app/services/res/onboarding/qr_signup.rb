# this class handles signups through QR codes (and hence unique start-phrases)
# The parameters coming in are -
#
# mobile_number:
# state_name:
# program_name:
# qr_identifier:
# language_code:
# condition_area:
#

module Res
  module Onboarding
    class QrSignup < Res::Onboarding::Base

      attr_accessor :qr_code, :qr_code_params, :program_id, :state_id, :qr_code_id, :language_id,
                    :res_user, :textit_group, :condition_area_id

      def initialize(logger, qr_code_params)
        super(logger)
        self.qr_code_params = qr_code_params
      end

      def call
        # first extract values for language, state etc from params
        self.program_id = NooraProgram.id_for(self.qr_code_params[:program_name])
        self.state_id = State.id_for(self.qr_code_params[:state_name])
        self.qr_code_id = QrCode.id_from_text_identifier(self.qr_code_params[:qr_identifier])
        self.qr_code = QrCode.find_by(id: qr_code_id)
        self.language_id = Language.with_code(self.qr_code_params[:language_code])&.id
        self.condition_area_id = ConditionArea.id_for(self.qr_code_params[:condition_area])


        # TODO - add validations if the request params don't have matching values for the QR

        # first make sure all compulsory attributes are present
        if self.program_id.blank?
          self.errors << "Program name is blank or invalid"
          return self
        end

        if self.state_id.blank?
          self.errors << "State name is blank or invalid"
          return self
        end

        if self.qr_code.blank?
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
          if self.res_user.program_id == self.qr_code.noora_program_id &&
            self.res_user.state_id == self.qr_code.state_id
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
          # i.e. the user doesn't already exist in the database
          unless create_res_user
            return self
          end
        end

        # now add a signup tracker that logs this particular signup event
        unless add_signup_tracker
          return self
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

      def onboarding_method
        "qr_code"
      end

      def qr_code_identifier
        self.qr_code&.text_identifier
      end


      def create_res_user
        self.res_user = User.new(
          language_preference_id: self.language_id,
          program_id: self.program_id,
          state_id: self.state_id,
          whatsapp_onboarding_date: DateTime.now,
          signed_up_to_whatsapp: true,
          mobile_number: self.qr_code_params[:mobile_number]
        )

        unless self.res_user.save
          self.errors << self.res_user.errors.full_messages
          return false
        end

        # if condition area is present, add condition area to user
        self.res_user.add_condition_area(self.program_id, self.condition_area_id)
        # TODO - modify this to make add_condition_area return true/false
        # unless self.res_user.add_condition_area(self.program_id, self.condition_area_id)
        #   self.errors << self.res_user.errors.full_messages
        #   return false
        # end

        true
      end


      def update_res_user
        unless self.res_user.update(
          language_preference_id: self.language_id,
          program_id: self.program_id,
          state_id: self.state_id,
          whatsapp_onboarding_date: DateTime.now,
          signed_up_to_whatsapp: true,
        )
          self.errors << self.res_user.errors.full_messages
          return false
        end

        # if condition area is present, add condition area to user
        self.res_user.add_condition_area(self.program_id, self.condition_area_id)

        true
      end


      def add_signup_tracker
        tracker = self.res_user.user_signup_trackers.build(
          noora_program_id: self.program_id,
          language_id: self.language_id,
          onboarding_method_id: OnboardingMethod.id_for(:qr_code),
          state_id: self.state_id,
          qr_code_id: self.qr_code_id,
          condition_area_id: self.condition_area_id,
          completed: false
        )

        unless tracker.save
          self.errors << tracker.errors.full_messages
          return false
        end
        true
      end


      def retrieve_textit_group
        self.textit_group = TextitGroup.where(program_id: self.program_id,
                                              language_id: self.language_id,
                                              state_id: self.state_id,
                                              condition_area_id: self.condition_area_id,
                                              onboarding_method_id: OnboardingMethod.id_for(:qr_code)).first

        if self.textit_group.blank?
          self.errors << "Textit group not found for user with number: #{self.res_user.mobile_number}"
        end
      end

    end
  end
end
