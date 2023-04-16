class AddConditionAreaToQrCodesProperlyThisTime < ActiveRecord::Migration[5.2]
  def change
    remove_column :qr_codes, :condition_areas_id
    add_reference :qr_codes, :condition_area
  end
end
