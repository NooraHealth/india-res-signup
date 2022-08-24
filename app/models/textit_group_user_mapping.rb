# == Schema Information
#
# Table name: textit_group_user_mappings
#
#  id              :bigint           not null, primary key
#  textit_group_id :integer
#  user_id         :integer
#  active          :boolean          default(FALSE)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class TextitGroupUserMapping < ApplicationRecord

  belongs_to :textit_group
  belongs_to :user
  
end
