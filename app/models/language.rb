# == Schema Information
#
# Table name: languages
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  iso_code   :string
#
class Language < ApplicationRecord

  include Seedable

  def self.values
    [
      :english,
      :hindi,
      :kannada,
      :telugu,
      :punjabi,
      :marathi
    ]
  end
end
