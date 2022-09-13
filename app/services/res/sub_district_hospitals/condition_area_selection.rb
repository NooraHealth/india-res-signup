# this operation takes as input the condition area of the user who is selecting it
# Can happen over IVR or WA, depending on the parameter `user_mobile_number` in the params

module Res
  module SubDistrictHospitals
    class ConditionAreaSelection < Res::SubDistrictHospitals::Base

      attr_accessor :exotel_params, :parsed_exotel_params, :res_user, :condition_area_id

      def initialize(exotel_params)
        super()
        self.exotel_params = exotel_params
      end


      def call
        self.message_logger = Logger.new("#{Rails.root}/log/sub_district_hospitals_condition_area_selection.log")

        # parse exotel params to get a simple hash with details like
        self.parsed_exotel_params = ExotelApi::ParseExotelParams.(self.exotel_params)

        # extract condition area of the user from params
        self.condition_area_id = ConditionArea.id_for(self.exotel_params[:condition_area].to_s)

        # check if the user already exists
        self.res_user = User.find_by mobile_number: self.parsed_exotel_params[:user_mobile]
        if self.res_user.blank?
          self.errors = "User not found in DB"
        else
          unless self.res_user.update(condition_area_id: self.condition_area_id)
            self.errors = self.res_user.errors.full_messages
          end
        end

        self
      end
    end
  end
end