class CreateUserImportJobs < ActiveRecord::Migration[7.0]
  def change
    create_table :user_import_jobs do |t|
      t.datetime :import_date
      t.integer :number_of_users

      t.timestamps
    end
  end
end
