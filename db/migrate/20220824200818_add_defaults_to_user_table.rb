class AddDefaultsToUserTable < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :language_selected, :boolean, default: false
    change_column :users, :signed_up_to_whatsapp, :boolean, default: false
    change_column :users, :signed_up_to_ivr, :boolean, default: false
  end
end
