class AddParamsToUserImportListItem < ActiveRecord::Migration[7.0]
  def change
    add_column :user_import_job_items, :api_params, :jsonb
  end
end
