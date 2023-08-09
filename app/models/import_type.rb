# == Schema Information
#
# Table name: import_types
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class ImportType < ApplicationRecord
  include Seedable

  def self.values
    [
      :user
    ]
  end

end
