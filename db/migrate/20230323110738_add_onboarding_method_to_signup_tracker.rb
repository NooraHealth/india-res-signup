class AddOnboardingMethodToSignupTracker < ActiveRecord::Migration[5.2]
  def change
    add_reference :user_signup_trackers, :onboarding_method
  end
end
