class AddFlagToRecordIfUserIsOnWhatsapp < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :registered_on_whatsapp, :boolean, default: true
  end
end
