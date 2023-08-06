class CreateUserImportJobItems < ActiveRecord::Migration[7.0]
  def change
    create_table :user_import_job_items do |t|
      t.references :user_import_job, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :import_status, null: false, foreign_key: true

      t.timestamps
    end
  end
end
