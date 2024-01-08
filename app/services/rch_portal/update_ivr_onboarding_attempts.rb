# this class updates the onboarding attempts for a user
# And also adds signup trackers for every call received by the user

module RchPortal
  class UpdateIvrOnboardingAttempts < RchPortal::Base

    attr_accessor :exotel_params, :parsed_params, :rch_user, :exophone

    def initialize(logger, params)
      super(logger)
      self.exotel_params = params
    end

    def call
      # first parse the webhooks params that are sent in the callback
      self.parsed_params = ExotelWebhook::ParseIvrCallStatusWebhook.(self.exotel_params)

      # first look for the user
      self.rch_user = User.find_by mobile_number: self.parsed_params[:user_mobile]
      if self.rch_user.blank?
        self.errors << "User not found with mobile number #{self.parsed_params[:mobile_number]}"
        return self
      end

      # next look for the exophone
      self.exophone = Exophone.find_by virtual_number: self.parsed_params[:exophone]

      # now add the call_sids to user signup tracker
      self.parsed_params[:call_sids].each do |call_details|
        call_sid = call_details[:call_sid]
        status = call_details[:status]
        if self.rch_user.user_event_trackers.find_by(call_sid: call_sid).present?
          # i.e. this call has already been recorded as a successful signup
          next
        end

        add_signup_tracker(call_sid, status)
      end

      # update onboarding attempts for this user
      # Ideally, this number should be equal to the number of ivr calls made to the
      # user as recorded in the user_event_tracker table
      # The number of unique campaigns will tell us the number of onboarding attempts
      # onboarding_attempts = self.rch_user.user_event_trackers.pluck(:campaign_sid).uniq.count
      # self.rch_user.update(onboarding_attempts: onboarding_attempts)

      self.rch_user.update(onboarding_attempts: (self.rch_user.onboarding_attempts + 1))

      self

    end

    private

    def add_signup_tracker(call_sid, status)
      tracker = self.rch_user.user_event_trackers.build(
        noora_program_id: NooraProgram.id_for(:rch),
        language_id: self.rch_user.language_preference_id,
        onboarding_method_id: OnboardingMethod.id_for(:ivr),
        state_id: self.rch_user.state_id,
        call_sid: call_sid,
        exophone_id: self.exophone.id,
        call_status: status,
        campaign_sid: self.parsed_params[:campaign_sid],
        event_timestamp: DateTime.now,
        call_direction: "outbound"
      )

      unless tracker.save
        self.errors << tracker.errors.full_messages
        return false
      end
      true
    end
  end
end