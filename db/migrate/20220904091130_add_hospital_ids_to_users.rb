class AddHospitalIdsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :hospital_id, :integer, references: "Hospital", foreign_key: true, index: true
  end
end