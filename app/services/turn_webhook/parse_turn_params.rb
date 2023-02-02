# this operation will parse Turn webhook parameters, and return a hash with the details of the user
# Output hash:
# {
#
# }

module TurnWebhook

  # the output of this particular class will be a hash that contains key value pairs
  # corresponding to each key of the WhatsappMessage model that can then be saved to DB

  class ParseTurnParams < ApplicationService

    attr_accessor :turn_params, :message_params, :direction, :whatsapp_id, :user

    def initialize(params)
      self.turn_params = params.to_h.with_indifferent_access rescue {}
      self.message_params = {}
    end

    # where the magic happens. This method will return a hash that will contain
    # the respective parameters that go into a WhatsappMessage object
    def call
      # using Hashie so that we can do a deep_find for specific keys within the
      # nested hash that is returned by the Turn Webhook API
      self.turn_params = self.turn_params.extend Hashie::Extensions::DeepFind

      set_menu_name
      set_whatsapp_id
      set_user_details

      timestamp = DateTime.strptime(self.turn_params.deep_find("timestamp"), "%s") rescue DateTime.now
      message_id = self.turn_params.deep_find("id")

      # the below field will apply only to outbound messages that are in reply to some prompt by a user
      # Turn lets us specify automation flows, and this holds the original prompt to which turn is replying
      # ONLY APPLIES TO OUTBOUND MESSAGES
      replied_to_message_id = self.turn_params.deep_find("in_reply_to")

      self.message_params.merge!(
        timestamp: timestamp,
        whatsapp_message_id: message_id,
        reply_to_whatsapp_id: replied_to_message_id,
        user_whatsapp_id: self.whatsapp_id
      )

      # returns the params parsed form the web request
      self.message_params
    end


    private

    # this method finds the whatsapp user by id, but if the user is not available,
    # then creates one
    def set_user_details

      # we have to do the below cases only if the user is a new user coming
      # to use our bot for the first time
      name = self.turn_params.deep_find("name")
      mobile_number = self.turn_params.deep_find("owner")
      self.message_params.merge!(
        mobile_number: mobile_number,
        user_whatsapp_number: mobile_number,
        name: name
      )
    end


    # this method extracts the whatsapp_id of the user based on the
    # type of message that is being parsed - inbound or outbound
    def set_whatsapp_id
      case self.direction
      when "inbound"
        # in inbound messages, the whatsapp ID of the user is stored in
        # an attribute called "wa_id" in the incoming hash
        self.whatsapp_id = self.turn_params.deep_find("wa_id") || self.turn_params.deep_find("from")
        # handle outbound cases here
      when "outbound"
        # in outbound messages, the whatsapp ID of the user is stored in
        # an attribute called "to" in the incoming hash
        self.whatsapp_id = self.turn_params.deep_find("to")
      end
    end


    # menu name is set only for outbound messages - it's a turn specific attribute
    # that basically talks about the automation menu that is being accessed for
    def set_menu_name
      case self.direction
        # we only need to handle the case where the outbound messages, as inbound
        # messages don't have the turn menu attribute, by definition
      when "outbound"
        self.message_params[:turn_menu_name] = self.turn_params.deep_find("name")
      end
    end

    def retrieve_language(content)
      content = content[0..5]
      prose_content = content.prose.sort
      begin
        if prose_content.first == "latin"
          return Language.id_for(:english)
        elsif prose_content.first == "devanagari"
          return Language.id_for(:hindi)
        elsif prose_content.first == "bengali_assamese"
          return Language.id_for(:bengali)
        else
          return Language.id_for(:english)
        end
      rescue
        return Language.id_for(:english)
      end
    end

  end
end