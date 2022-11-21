class AddStateIdToExophones < ActiveRecord::Migration[5.2]
  def change
    add_reference :exophones, :state
  end
end