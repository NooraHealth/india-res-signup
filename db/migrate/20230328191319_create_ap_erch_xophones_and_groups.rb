class CreateApErchXophonesAndGroups < ActiveRecord::Migration[5.2]
  def change

    exo = Exophone.new(virtual_number: "04069179581", state_id: State.id_for("Andhra Pradesh"), program_id: NooraProgram.id_for(:rch))
    exo.save

    tt = TextitGroup.new(program_id: NooraProgram.id_for(:rch),
                         textit_id: "22cc9e61-9a2b-4acc-a5ef-9dcb35e29f47",
                         state_id: State.id_for("Andhra Pradesh"),
                         exotel_number: "04069179581",
                         name: "RCH_Neutral_AP",
                         condition_area_id: ConditionArea.id_for(:anc))
    tt.save
  end
end
