module Res
  module DistrictHospitals
    class Base < ApplicationService

      attr_accessor :logger, :errors, :res_user, :exophone, :textit_group, :parsed_exotel_params

      def initialize(logger)
        self.logger = logger
        self.errors = []
      end

      protected

      def retrieve_user
        self.res_user = User.find_by(mobile_number: self.parsed_exotel_params[:user_mobile])
        if self.res_user.present?
          self.logger.info("SUCCESSFULLY FOUND user in DATABASE with number #{self.res_user.mobile_number}")
        end
      end

      def retrieve_exophone
        self.exophone = Exophone.find_by(virtual_number: self.parsed_exotel_params[:exophone])
        if self.exophone.blank?
          self.logger.info("Couldn't find exophone: #{self.parsed_exotel_params[:exophone]} in the database")
          self.errors << "Exophone not found in database"
        end
      end


      # this logic here makes sense because the details of which textit group
      # the user belongs to is uniquely identified by the exophone number
      def retrieve_textit_group
        condition_area_id = self.exophone.condition_area_id
        program_id = self.exophone.program_id
        language_id = self.exophone.language_id
        state_id = self.exophone.state_id # even if this field is nil, it works because the default value for this field is nil
        self.textit_group = TextitGroup.where(condition_area_id: condition_area_id,
                                              program_id: program_id,
                                              language_id: language_id,
                                              state_id: state_id).first
        if self.textit_group.blank?
          self.errors << "Textit group not found for user with number: #{self.res_user.mobile_number}"
        end
      end

    end
  end
end
