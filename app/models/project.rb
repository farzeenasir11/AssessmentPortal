class Project < ApplicationRecord
  has_many :user_projects, dependent: :destroy
  has_many :users, through: :user_projects, dependent: :destroy
  has_many :assessments, dependent: :destroy

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "id", "project_name", "updated_at"]
  end
end
