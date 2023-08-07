class ReseedOnboardingMethods < ActiveRecord::Migration[5.2]
  def change
    OnboardingMethod.seed_data
  end
end
