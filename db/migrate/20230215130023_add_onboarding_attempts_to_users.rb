class AddOnboardingAttemptsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :onboarding_attempts, :integer, default: 0
  end
end
