class UserResult < ApplicationRecord
  belongs_to :user_assessment
  belongs_to :question
  belongs_to :option
end
