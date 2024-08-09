class Assessment < ApplicationRecord
  belongs_to :project

  has_many :questions, dependent: :destroy
  has_many :user_assessments, dependent: :destroy
  has_many :users, through: :user_assessments
  #has_many :user_results changings made here
  
end
