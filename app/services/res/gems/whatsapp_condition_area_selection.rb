module Res
  module Gems
    class WhatsappConditionAreaSelection < Res::Gems::Base

      attr_accessor :params, :logger, :res_user

      def initialize(logger, params)
        super(logger)
        self.params = params
      end


      def call
        case params[:condition_area]
        when "hypertension"
          condition_area_ids = [ConditionArea.id_for(:hypertension)]
        when "diabetes"
          condition_area_ids = [ConditionArea.id_for(:diabetes)]
        when "d_and_h"
          condition_area_ids = ConditionArea.ids_for(:diabetes, :hypertension)
        end

        # find user in the DB, return error otherwise
        self.res_user = User.find_by textit_uuid: self.params["contact"]["uuid"]
        if self.res_user.blank?
          self.errors << "User not found with Whatsapp Mobile Number: #{self.params[:whatsapp_mobile]}"
          return self
        end

        # add user to the respective condition area
        self.condition_area_ids.each do |ca_id|
          self.res_user.add_condition_area(NooraProgram.id_for(:gems), ca_id)
        end

        self
      end

    end
  end
end
