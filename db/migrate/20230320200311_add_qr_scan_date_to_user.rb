class AddQrScanDateToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :qr_scan_date, :datetime
  end
end
