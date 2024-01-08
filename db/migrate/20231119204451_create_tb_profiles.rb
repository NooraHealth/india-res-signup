class CreateTbProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :tb_profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.string :facility_state
      t.string :facility_district
      t.string :facility_tu
      t.string :facility_phi
      t.datetime :enrolment_date
      t.string :patient_taluka
      t.string :patient_state
      t.string :patient_district
      t.string :patient_tu
      t.string :pin_code
      t.string :basis_of_diagnosis_test_name
      t.string :basis_of_diagnosis_final_interpretation

      t.timestamps
    end
  end
end
