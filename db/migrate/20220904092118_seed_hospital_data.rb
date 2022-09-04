class SeedHospitalData < ActiveRecord::Migration[5.2]
  def change
    Hospital.seed_data
  end
end
