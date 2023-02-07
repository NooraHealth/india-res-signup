# this operation will accept user records in bulk and add them to our database
# in bulk

module RchPortal
  class Import < RchPortal::Base

    attr_accessor :records, :result, :raw_params

    def initialize(logger, params)
      super(logger)
      self.raw_params = params
      self.records = params[:records]
    end

    def call
      # now we have the list of users that need to be imported in

      self.result = []

      self.records.each do |record|

        state_id = record[:state_id] || State.id_for(record[:state_name])

        # first see if the user already exists in the database
        existing_user = User.find_by mobile_number: "0#{record[:mobile_number]}"
        if existing_user.present?
          self.result << {
            "#{record[:rch_id]}" => "User already present in database"
          }
        end

        user = User.new(mobile_number: "0#{record[:mobile_number]}",
                        program_id: NooraProgram.id_for(:rch),
                        state_id: state_id,
                        last_menstrual_period: record[:last_menstrual_period],
                        expected_date_of_delivery: record[:expected_date_of_delivery]
                        )

        # if the user could not be saved, build result object with the respective error
        # message for the user
        unless user.save
          self.result << {
            "#{record[:rch_id]}" => "Could not import user because: #{user.errors.full_messages.to_sentence}"
          }
          next
        end

        rch_profile = user.build_rch_profile(rch_id: record[:rch_id],
                                             name: record[:name],
                                             health_facility: record[:health_facility],
                                             health_block: record[:health_block],
                                             village: record[:village],
                                             husband_name: record[:husband_name],
                                             mother_age: record[:mother_age],
                                             anm_name: record[:anm_name],
                                             anm_contact: record[:anm_contact],
                                             asha_name: record[:asha_name],
                                             asha_contact: record[:asha_contact],
                                             registration_date: record[:registration_date],
                                             high_risk_details: record[:high_risk_details]
                                            )

        # if the user's profile could not be saved, build result object with the correct error message
        unless rch_profile.save
          self.result << {
            "#{record[:rch_id]}" => "Could not create RCH profile for user with mobile number: #{user.mobile_number}"
          }
          next
        end

        # if we reach here that means the user and RCH Profile of the user has
        # been saved successfully in the database
        self.result << {
          "#{record[:rch_id]}" => "User successfully imported!"
        }

        self
      end
    end
  end
end
