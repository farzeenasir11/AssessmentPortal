class User < ApplicationRecord
  has_many :user_projects
  has_many :projects, through: :user_projects
  has_many :user_assessments
  has_many :assessments, through: :user_assessments
  has_many :user_results
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: { user: 0, admin: 1 }
  validates :username, presence: true, uniqueness: { case_sensitive: false }

  #changings made here
  def self.ransackable_attributes(auth_object = nil)
    ["email", "created_at", "updated_at"]
  end

end
