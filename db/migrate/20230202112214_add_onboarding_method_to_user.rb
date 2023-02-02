class AddOnboardingMethodToUser < ActiveRecord::Migration[5.2]
  def change
    add_reference :users, :onboarding_method, foreign_key: true
  end
end
