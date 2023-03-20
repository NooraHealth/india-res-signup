class AddOnboardingMethodToTextitGroup < ActiveRecord::Migration[5.2]
  def change
    add_reference :textit_groups, :onboarding_method
  end
end
