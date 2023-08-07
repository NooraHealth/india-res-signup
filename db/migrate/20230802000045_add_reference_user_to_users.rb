class AddReferenceUserToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :reference_user_id, :integer, foreign_key: true, index: true
  end
end
