class SeedExophoneAndTextitGroupModels < ActiveRecord::Migration[5.2]
  def change
    exophones = [
      # Karnataka ANC
      {
        virtual_number: "08047093145",
        condition_area_id: ConditionArea.id_for(:anc),
        program_id: NooraProgram.id_for(:mch),
        language_id: Language.id_for(:kannada)
      },

      # Karnataka PNC
      {
        virtual_number: "08046809362",
        condition_area_id: ConditionArea.id_for(:pnc),
        program_id: NooraProgram.id_for(:mch),
        language_id: Language.id_for(:kannada)
      }
    ]

    exophones.each do |exophone|
      Exophone.create(exophone)
    end


    textit_groups = [
      {
        name: "Karnataka ANC 08047093145",
        condition_area_id: ConditionArea.id_for(:anc),
        program_id: NooraProgram.id_for(:mch),
        language_id: Language.id_for(:kannada),
        textit_id: "20d3e1d7-1958-467e-affd-8b55b722dd01"
      },
      {
        name: "Karnataka PNC 08046809362",
        condition_area_id: ConditionArea.id_for(:pnc),
        program_id: NooraProgram.id_for(:mch),
        language_id: Language.id_for(:kannada),
        textit_id: "49ff694a-540f-48df-9bed-71d0c7457631"
      }
    ]

    textit_groups.each do |textit_group|
      TextitGroup.create(textit_group)
    end

  end
end
