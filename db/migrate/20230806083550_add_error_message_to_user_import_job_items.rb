class AddErrorMessageToUserImportJobItems < ActiveRecord::Migration[7.0]
  def change
    add_column :user_import_job_items, :error_message, :text
  end
end
