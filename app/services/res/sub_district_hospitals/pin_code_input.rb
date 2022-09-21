# this class will take the pin code of the user as an input and update it on the
# user's model. Input can come in via multiple channels:
# - IVR: will come in via Exotel's API which will contain it in the variable "digits"
# - WA: will come in via TextIt's webhook which will also send it as a variable "digits"

# the pin code proper will be contained within the variable "digits" inside params

module Res
  module SubDistrictHospitals
    class PinCodeInput < Res::SubDistrictHospitals::Base

      attr_accessor :params

      def initialize(logger, params)
        super(logger)
        self.params = params
      end


      def call


      end
    end
  end
end