class CreateImportTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :import_types do |t|
      t.string :name

      t.timestamps
    end

    add_reference :import_jobs, :import_types
  end
end
