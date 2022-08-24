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
#
class Exophone < ApplicationRecord

  belongs_to :language, optional: true
  belongs_to :condition_area, optional: true
  belongs_to :program, class_name: "NooraProgram", optional: true

end
