class AddTbFieldsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :tb_treatment_start_date, :datetime
  end
end
