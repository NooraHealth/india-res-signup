class UserConditionAreaMapping < ApplicationRecord
  belongs_to :user
  belongs_to :condition_area
end
