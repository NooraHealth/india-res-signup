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
                                     incoming_call_date: DateTime.now)
            unless self.res_user.save
              self.errors << self.res_user.errors.full_messages
              return self
            end
          else # i.e. the user already exists and is calling again for signing up with the HP service, so in this case
            # update the state and language preferences of the user accordingly.
            self.res_user.update(language_preference_id: Language.id_for(:hindi),
                                 program_id: NooraProgram.id_for(:mch),
                                 state_id: State.id_for("Himachal Pradesh"),
                                 incoming_call_date: DateTime.now)

          end

          # also create an entry on the signup tracker which records details of a user's signup
          self.res_user.user_event_trackers.build(noora_program_id: NooraProgram.id_for(:mch),
                                                   language_id: self.res_user.language_preference_id,
                                                   active: true).save

          # adding new condition area to user
          self.res_user.add_condition_area(NooraProgram.id_for(:mch), ConditionArea.id_for(:pnc))

          self
        end
      end
    end
  end
end