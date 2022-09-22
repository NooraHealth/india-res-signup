class CreateUserSignupTrackers < ActiveRecord::Migration[5.2]
  def change
    create_table :user_signup_trackers do |t|
      t.references :user, foreign_key: true
      t.references :condition_area, foreign_key: true
      t.references :noora_program, foreign_key: true
      t.references :language, foreign_key: true
      t.boolean :active, default: false

      t.timestamps
    end
  end
end
