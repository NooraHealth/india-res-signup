class ChangeColumnNameInImportJobs < ActiveRecord::Migration[7.0]
  def change
    rename_column :import_jobs, :number_of_users, :number_of_records
  end
end
