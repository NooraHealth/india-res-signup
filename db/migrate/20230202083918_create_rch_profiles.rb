class CreateRchProfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :rch_profiles do |t|
      t.string :name
      t.text :health_facility
      t.text :health_block
      t.text :health_sub_facility
      t.text :village
      t.string :rch_id
      t.string :husband_name
      t.integer :mother_age
      t.text :anm_name
      t.string :anm_contact
      t.text :asha_contact
      t.string :asha_mobile
      t.datetime :registration_date
      t.text :high_risk_details
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
