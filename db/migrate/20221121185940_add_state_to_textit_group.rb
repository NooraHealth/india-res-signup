class AddStateToTextitGroup < ActiveRecord::Migration[5.2]
  def change
    add_reference :textit_groups, :state
  end
end
