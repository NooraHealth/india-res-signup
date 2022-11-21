class AddProgramToCooonditionAreaMappings < ActiveRecord::Migration[5.2]
  def change
    UserConditionAreaMapping.where(noora_program_id: nil).each do |ucm|
      user = ucm.user
      ucm.update(noora_program_id: user.program_id)
    end
  end
end
