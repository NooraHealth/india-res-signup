# == Schema Information
#
# Table name: user_condition_area_mappings
#
#  id                :bigint           not null, primary key
#  user_id           :bigint
#  condition_area_id :bigint
#  noora_program_id  :bigint
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
class UserConditionAreaMapping < ApplicationRecord
  belongs_to :user
  belongs_to :condition_area
  
end
