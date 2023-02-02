class AddDateColumnsToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :last_menstrual_period, :datetime
    add_column :users, :expected_date_of_delivery, :datetime
  end
end
