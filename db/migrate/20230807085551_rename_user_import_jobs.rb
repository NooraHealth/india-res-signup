class RenameUserImportJobs < ActiveRecord::Migration[7.0]
  def change
    rename_table :user_import_job_items, :import_job_items
    rename_table :user_import_jobs, :import_jobs
  end
end
