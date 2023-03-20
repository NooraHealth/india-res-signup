class AddQrCodeToSignupTracker < ActiveRecord::Migration[5.2]
  def change
    add_reference :user_signup_trackers, :qr_code
  end
end
