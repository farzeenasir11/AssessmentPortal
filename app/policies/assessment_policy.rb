class AssessmentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        # Adjust the scope to fetch assessments associated with the user
        scope.joins(:user_assessments).where(user_assessments: { user_id: user.id })
      end
    end
  end

  def index?
    #new changings made here as well
    user.admin? || user.projects.include?(record) || user.user?
  end

  def show?
    user.admin? || user.user?
  end

  def attempt?
    user.present?
    # return false unless user.role == 'user'

    # return false unless record.available?

    # # Check if the user has already completed the assessment (assuming you have a method for this)
    # !UserAssessment.exists?(user: user, assessment: record, completed: true)
  end
  

  def submit_attempt?
    user.present?
  end
#policy for assigning users
  def assign_user?
    user.admin?
  end

  def new?
    user.admin?
  end

  def create?
    new?
  end

  def edit?
    user.admin?
  end

  def update?
    edit?
  end

  def destroy?
    user.admin?
  end
end
