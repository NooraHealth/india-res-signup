# == Schema Information
#
# Table name: import_statuses
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class ImportStatus < ApplicationRecord

  include Seedable

  def self.values
    [
      :queued,
      :in_progress,
      :completed,
      :failed
    ]
  end
end

