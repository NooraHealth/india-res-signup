class CreateHospitals < ActiveRecord::Migration[5.2]
  def change
    create_table :hospitals do |t|
      t.string :name
      t.references :state, foreign_key: true, index: true

      t.timestamps
    end
  end
end
