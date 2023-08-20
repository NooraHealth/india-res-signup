# This class contains logic to parse Exotel's webhook params through its Passthru applet
# Sample packet of params looks as follows:
# {
#   "CallSid"=>"5f05e2525e42e38f869481b47adf168n",
#   "CallFrom"=>"09949633981",
#   "CallTo"=>"04048215415",
#   "Direction"=>"incoming",
#   "Created"=>"Tue, 23 Aug 2022 22:31:51",
#   "DialCallDuration"=>"0",
#   "StartTime"=>"2022-08-23 22:31:51",
#   "EndTime"=>"1970-01-01 05:30:00",
#   "CallType"=>"call-attempt",
#   "DialWhomNumber"=>"",
#   "flow_id"=>"399026",
#   "tenant_id"=>"121580",
#   "From"=>"09949633981",
#   "To"=>"04048215415",
#   "CurrentTime"=>"2022-08-23 22:31:52",
#   "controller"=>"exotel/audio_message",
#   "action"=>"unicef_sncu_start"
# }

module ExotelWebhook
  class ParseExotelParams < ApplicationService

    attr_accessor :exotel_params

    # here we can assume that params is a Hash object,
    # and not a ApplicationController::Params object
    # But just in case, we shall parse it for sanity
    def initialize(params)
      self.exotel_params = params.to_h.with_indifferent_access rescue {}
    end

    def call
      self.exotel_params = self.exotel_params.extend Hashie::Extensions::DeepFind

      direction = self.exotel_params.deep_find("Direction")

      # the user's mobile number is always going to be the CallFrom attribute
      user_mobile = self.exotel_params.deep_find("CallFrom")

      current_time = self.exotel_params.deep_find("CurrentTime")

      language_id = self.exotel_params.deep_find("language_id")

      call_to = self.exotel_params["CallTo"]
      exophone = self.exotel_params["To"]

      call_sid = self.exotel_params["CallSid"]

      # TODO - add more params as they become relevant

      {
        direction: direction,
        user_mobile: user_mobile,
        current_time: current_time,
        language_id: language_id,
        call_to: call_to,
        exophone: exophone,
        call_sid: call_sid,
        language_code: language_id
      }
    end

  end
end

