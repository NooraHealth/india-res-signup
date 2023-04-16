class AddConditionAreaToQrCodes < ActiveRecord::Migration[5.2]
  def change
    add_reference :qr_codes, :condition_areas
  end
end
