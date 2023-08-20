class MakeUserIdNullableInImportJobItems < ActiveRecord::Migration[7.0]
  def change
    change_column :import_job_items, :user_id, :integer, null:true
  end
end
