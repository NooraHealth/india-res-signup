
module TbRes
  class Base < ApplicationService

    attr_accessor :logger, :errors, :tb_user

    def initialize(logger)
      self.logger = logger
      self.errors = []
    end

    protected

    # If a user is already on TextIt, the user is added to an existing group which is identified
    # from the TextitGroup class
    def add_user_to_existing_group
      params = {id: self.res_user.id, uuid: self.res_user.textit_uuid}
      params[:textit_group_id] = self.textit_group&.textit_id
      params[:logger] = self.logger
      params[:fields] = {
        "date_joined" => (self.res_user.whatsapp_onboarding_date || DateTime.now),
        "language_selected" => (self.res_user.language_selected ? "1" : "0"),
        "tb_treatment_date" => self.res_user.tb_treatment_start_date,
      }

      op = TextitRapidproApi::UpdateGroup.(params)
      if op.errors.present?
        self.errors = op.errors
        return false
      end
      true
    end
  end
end
