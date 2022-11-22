# This operation, specific to HP updates the user's Whatsapp number to the one they enter on Exotel
# This assumes that the user has already been created with the respective condition areas and that
# they will have a mobile number associated with their account already

module Res
  module DistrictHospitals
    module Hp
      class ChangeWhatsappNumber < Res::DistrictHospitals::Base

        attr_accessor :exotel_params, :parsed_exotel_params, :res_user,
                      :whatsapp_number

        def initialize(logger, exotel_params)
          super(logger)
          self.exotel_params = exotel_params
        end

        def call

          # extract the number entered by the user into a separate variable
          self.whatsapp_number = self.exotel_params["digits"].gsub("\"", "")

          # format the number based on the way in which they entered it
          self.whatsapp_number = format_whatsapp_number(self.whatsapp_number)
          return self if self.errors.present?

          retrieve_user
          if self.res_user.blank?
            self.errors << "User not found"
          end
          return self if self.errors.present?

          # update the user's WA number to the one entered through Exotel
          self.res_user.update(whatsapp_mobile_number: self.whatsapp_number)

          op = Res::DistrictHospitals::ExotelWaSignup.(self.logger, self.exotel_params)
          if op.errors.present?
            self.errors = op.errors
          end

          self
        end


        private

        def format_whatsapp_number(number)
          if number.length == 10
            "0#{number}"
          elsif number.length < 10
            self.errors << "Number is not of sufficient length"
            return number
          end
        end
      end
    end
  end
end