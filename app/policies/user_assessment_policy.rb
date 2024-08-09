class UserAssessmentPolicy < ApplicationPolicy
  def index?
    user.admin? || user.user?
  end

  def show?
    user.admin? ||  user == user_assessment.user || user == record.user
  end

  def attempt?
    user.user? && record.user == user
  end

  def destroy?
    user.admin?
  end

  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.where(user: user)
      end
    end
  end
  private

  def user_assessment
    record
  end
end
