class Option < ApplicationRecord
  belongs_to :question
  has_many :user_results, dependent: :destroy
end
