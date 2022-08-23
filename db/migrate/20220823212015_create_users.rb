class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :mobile_number
      t.datetime :baby_date_of_birth
      t.datetime :date_of_discharge
      t.datetime :incoming_call_date
      t.integer :program_id, references: "NooraProgram", foreign_key: true, index: true
      t.integer :condition_area_id, references: "ConditionArea", foreign_key: true, index: true
      t.integer :language_preference_id, references: "Language", foreign_key: true, index: true
      t.boolean :language_selected
      t.boolean :signed_up_to_whatsapp
      t.boolean :signed_up_to_ivr
      t.string :textit_uuid
      t.string :whatsapp_id

      t.timestamps
    end
  end
end
