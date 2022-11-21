class UpdateConditionAreasForAllUsers < ActiveRecord::Migration[5.2]
  def change
    errors = []
    User.all.each do |user|
      condition_area = user.condition_area
      if condition_area.present?
        ucm = UserConditionAreaMapping.new(user_id: user.id, condition_area_id: condition_area.id, noora_program_id: user.program_id)
        unless ucm.save
          errors << ucm.errors.full_messages
        end
      end
    end

    # Printing the errors here in case users are missed
    puts errors
  end
end
