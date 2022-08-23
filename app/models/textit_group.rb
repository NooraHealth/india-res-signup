# == Schema Information
#
# Table name: textit_groups
#
#  id                :integer          not null, primary key
#  name              :string
#  program_id        :integer
#  textit_id         :string
#  condition_area_id :integer
#  exotel_number     :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
class TextitGroup < ApplicationRecord
end
