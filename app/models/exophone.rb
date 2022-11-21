# == Schema Information
#
# Table name: exophones
#
#  id                :bigint           not null, primary key
#  virtual_number    :string
#  language_id       :integer
#  condition_area_id :integer
#  program_id        :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  state_id          :bigint
#
class Exophone < ApplicationRecord

  validates :virtual_number, uniqueness: true

  belongs_to :language, optional: true
  belongs_to :condition_area, optional: true
  belongs_to :program, class_name: "NooraProgram", optional: true
  belongs_to :state, optional: true

end
