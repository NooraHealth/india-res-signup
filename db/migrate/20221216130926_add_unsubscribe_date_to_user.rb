class AddUnsubscribeDateToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :ivr_unsubscribe_date, :datetime
    add_column :users, :whatsapp_unsubscribe_date, :datetime
  end
end
