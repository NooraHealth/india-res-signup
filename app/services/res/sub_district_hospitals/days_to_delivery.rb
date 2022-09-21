# this class will take the number of days to delivery from the user as an input and calculate
# the date of birth of the baby, using the current date
# - IVR: will come in via Exotel's API which will contain the number of days in "digits"
# - WA: will come in via TextIt's webhook which will also send it as a variable inside "digits"

# the number of days proper will be contained inside a parameter called "digits"

module Res
  module SubDistrictHospitals
    class DaysToDelivery < Res::SubDistrictHospitals::Base

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