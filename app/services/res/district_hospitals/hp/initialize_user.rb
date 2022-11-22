# this class creates the user with all the initial conditions that we assume for a user from HP
# Condition Area - PNC
# Program: MCH
# State - Himachal Pradesh
# Language - Hindi

module Res
  module DistrictHospitals
    module Hp
      class InitializeUser < Res::DistrictHospitals::Base

        attr_accessor :exotel_params, :res_user, :parsed_exotel_params

        def initialize(logger, exotel_params)
          super(logger)
          self.exotel_params = exotel_params
        end


        def call
          # parse exotel params to get a simple hash with details like
          self.parsed_exotel_params = ExotelWebhook::ParseExotelParams.(self.exotel_params)

          # check if the user already exists, if not create them
          retrieve_user
          if self.res_user.blank?
            self.res_user = User.new(mobile_number: self.parsed_exotel_params[:user_mobile],
                                     language_preference_id: Language.id_for(:hindi),
                                     program_id: NooraProgram.id_for(:mch),
                                     state_id: State.id_for("Himachal Pradesh"),
                                     signed_up_to_whatsapp: true)
            unless self.res_user.save
              self.errors << self.res_user.errors.full_messages
            end

            # adding new condition area to user
            self.res_user.add_condition_area(program_id: NooraProgram.id_for(:mch))
          end

          self
        end
      end
    end
  end
end