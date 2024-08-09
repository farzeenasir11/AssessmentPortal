class Question < ApplicationRecord
  belongs_to :assessment

  has_many :options, dependent: :destroy
  has_many :user_results
  accepts_nested_attributes_for :options, allow_destroy: true
  
end
