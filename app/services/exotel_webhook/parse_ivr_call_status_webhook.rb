# This class contains logic to parse Exotel's webhook for calls initiated via API
# Sample packet of params looks as follows:
# {
#   "campaign_sid"=>"6c383e85383c05af6428d290a75894ef1744",
#   "from"=>"+917209994118",
#   "caller_id"=>"01141170849",
#   "call_sids"=>
#       [
#           { "call_sid"=>"2dd6bd5d0690552299173649a5821745",
#             "status"=>"no-answer"
#           },
#           {
#             "call_sid"=>"3a66b7e91e0f67d09c982b50b4241745",
#             "status"=>"no-answer"
#           },
#           { "call_sid"=>"53754ad9637f7860242cb79b82571745",
#             "status"=>"no-answer"
#           }
#       ],
#   "status"=>"failed",
#   "date_created"=>"2023-04-05T11:01:45+05:30",
#   "date_updated"=>"2023-04-05T11:37:58+05:30",
#   "webhook"=>
#   {"campaign_sid"=>"6c383e85383c05af6428d290a75894ef1744", "from"=>"+917209994118", "caller_id"=>"01141170849", "call_sids"=>[{"call_sid"=>"2dd6bd5d0690552299173649a5821745", "status"=>"no-answer"}, {"call_sid"=>"3a66b7e91e0f67d09c982b50b4241745", "status"=>"no-answer"}, {"call_sid"=>"53754ad9637f7860242cb79b82571745", "status"=>"no-answer"}], "status"=>"failed", "date_created"=>"2023-04-05T11:01:45+05:30", "date_updated"=>"2023-04-05T11:37:58+05:30"}}
# }

module ExotelWebhook
  class ParseIvrCallStatusWebhook < ApplicationService

    attr_accessor :exotel_params

    # here we can assume that params is a Hash object,
    # and not a ApplicationController::Params object
    # But just in case, we shall parse it for sanity
    def initialize(params)
      self.exotel_params = params.to_h.with_indifferent_access rescue {}
    end

    def call
      self.exotel_params = self.exotel_params.extend Hashie::Extensions::DeepFind

      user_mobile = self.exotel_params.deep_find("from")
      user_mobile = user_mobile[3..(user_mobile.length)]

      exophone = self.exotel_params.deep_find("caller_id")

      call_sids = self.exotel_params.deep_find("call_sids")

      campaign_sid = self.exotel_params.deep_find("campaign_sid")

      # TODO - add more params as they become relevant

      {
        user_mobile: "0#{user_mobile}",
        exophone: exophone,
        call_sids: call_sids,
        campaign_sid: campaign_sid
      }
    end

  end
end


