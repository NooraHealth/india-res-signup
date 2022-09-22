class AddWhatsappConfirmationToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :whatsapp_number_confirmed, :boolean, default: false
  end
end
