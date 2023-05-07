class AddQrCodeIdToTextitGroup < ActiveRecord::Migration[5.2]
  def change
    add_reference :textit_groups, :qr_code
  end
end
