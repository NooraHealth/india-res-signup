class AddWhatsappOnboardingDateToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :whatsapp_onboarding_date, :datetime
  end
end
