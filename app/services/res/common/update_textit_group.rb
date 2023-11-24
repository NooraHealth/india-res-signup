# this class will update the TextitGroup-User mapping based on user's movement
# in Textit. The parameters will be sent from Textit's webhook which updates
# the mapping on our database.
# # Parameters:
# # {
# #   "mobile_number"=>["whatsapp:91XXXXXXX", "tel:+91XXXXXX"]
# #   "group_name": "",
# #   "channel": "" # textit, turn etc.
# #   "group_textit_id": "Textit ID of the group that the user has joined"
# # }

module Res
  module Common
    class UpdateTextitGroup < Res::Common::Base

      attr_accessor :group_update_params, :user, :textit_group

      def initialize(logger, params)
        super(logger)
        self.group_update_params = params
      end

      def call
        # first look for the user from the params
        channel = self.group_update_params[:channel]
        mobile_number = extract_mobile_number(channel, group_update_params)
        if mobile_number.blank?
          self.errors << "Mobile number not found in params, or not formatted correctly"
          return self
        end

        # now look for the user using the mobile number
        # if the user is not found, raise an error and return
        self.user = User.find_by(mobile_number: mobile_number)
        if self.user.blank?
          self.errors << "User not found in database with mobile number: #{mobile_number}"
          return self
        end

        # now extract the textit group based on params and raise error if the `group_textit_id` field
        # does not contain valid textit group details
        textit_group_id = self.group_update_params[:group_textit_id]
        self.textit_group = TextitGroup.find_by(textit_id: textit_group_id)
        if self.textit_group.blank?
          self.errors << "Textit group not found in database with textit_id: #{textit_group_id}"
          return self
        end

        # create an object of UserTextitGroupMapping and save it
        # if the object is not saved, raise an error and return
        user_textit_group_mapping = UserTextitGroupMapping.new(
          user_id: self.user.id,
          textit_group_id: self.textit_group.id,
          event_timestamp: DateTime.now
        )
        if user_textit_group_mapping.save
          self.errors = user_textit_group_mapping.errors.full_messages
          return self
        end

        self

      end

    end
  end
end
