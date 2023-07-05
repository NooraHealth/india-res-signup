class AddTextEncodedToQrCodes < ActiveRecord::Migration[5.2]
  def change
    add_column :qr_codes, :text_encoded, :string
  end
end
