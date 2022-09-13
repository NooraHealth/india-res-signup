class AddWhatsappMobileNumberToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :whatsapp_mobile_number, :string
  end
end
