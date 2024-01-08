class CreateEventTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :user_event_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
