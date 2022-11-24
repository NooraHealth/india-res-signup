# For the GEMS project, this operation allows a user to select their condition area
# Can happen over IVR or WA, depending on the parameter `user_mobile_number` in the params

module Res
  module Gems
    class ConditionAreaSelection < Res::Gems::Base

      attr_accessor :exotel_params, :parsed_exotel_params, :res_user, :condition_area_ids

      def initialize(logger, exotel_params)
        super(logger)
        self.exotel_params = exotel_params
      end


      def call

        # parse exotel params to get a simple hash with details like
        self.parsed_exotel_params = ExotelWebhook::ParseExotelParams.(self.exotel_params)

        # extract condition area of the user from params
        case self.exotel_params[:condition_area]
        when "diabetes"
          self.condition_area_ids = [ConditionArea.id_for(self.exotel_params[:condition_area].to_s)]
        when "hypertension"
          self.condition_area_ids = [ConditionArea.id_for(self.exotel_params[:condition_area].to_s)]
        when "d_and_h"
          self.condition_area_ids = [ConditionArea.ids_for(:diabetes, :hypertension)]
        end
        self.logger.info("Condition area chosen by user: #{ConditionArea.find(self.condition_area_id).name}")

        # check if the user already exists
        self.res_user = User.find_by mobile_number: self.parsed_exotel_params[:user_mobile]
        if self.res_user.blank?
          self.errors = "User not found in DB"
        else
          # unless self.res_user.update(condition_area_id: self.condition_area_id)
          #   self.errors = self.res_user.errors.full_messages
          # end

          # add user to the respective condition area
          self.condition_area_ids.each do |ca_id|
            self.res_user.add_condition_area(NooraProgram.id_for(:gems), ca_id)
          end

          # To update the signup tracker, we will look for the existing active tracker.
          # For that object, if condition_area_id is nil they are signing up for GEMS again (because we would have created the tracker on the language selection operation),
          # so we can update the attribute to the right condition area
          # If condition_area_id already exists, make that inactive and create a new user signup tracker

          # active_tracker = self.res_user.active_signups.where(noora_program_id: NooraProgram.id_for(:gems)).first
          # if active_tracker.condition_area_id.present?
          #   active_tracker.update(active: false)
          #   new_tracker = active_tracker.dup
          #   new_tracker.update(condition_area_id: self.condition_area_id, active: true)
          # else
          #   active_tracker.update(condition_area_id: self.condition_area_id)
          # end

        end

        self
      end
    end
  end
end