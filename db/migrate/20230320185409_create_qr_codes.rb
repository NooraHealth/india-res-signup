class CreateQrCodes < ActiveRecord::Migration[5.2]
  def change
    create_table :qr_codes do |t|
      t.string :name
      t.string :link_encoded
      t.references :state, foreign_key: true
      t.references :noora_program, foreign_key: true
      t.string :text_identifier

      t.timestamps
    end
  end
end
