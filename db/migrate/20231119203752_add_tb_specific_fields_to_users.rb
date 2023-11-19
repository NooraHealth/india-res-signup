class AddTbSpecificFieldsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :tb_diagnosis_date, :datetime
    add_column :users, :whatsapp_unsubscribed_date, :datetime

    NooraProgram.seed_data
  end
end
