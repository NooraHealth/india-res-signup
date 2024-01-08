class AddPresentOnWaToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :present_on_wa, :boolean, default: false
  end
end
