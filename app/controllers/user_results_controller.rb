class UserResultsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin, only: [:index, :show]
  

  def index
    @search = User.ransack(params[:q])
    @users = @search.result
    if current_user.admin?
      if params[:q].present? && params[:q][:email_cont].present?
        user_ids = @users.pluck(:id)
        @user_results = UserResult.joins(:user_assessment)
                                  .where(user_assessments: { user_id: user_ids })
                                  .includes(user_assessment: [:user, :assessment])
      else
        @user_results = UserResult.includes(:user_assessment, user_assessment: [:user, :assessment])
      end
    else
      @user_results = UserResult.joins(:user_assessment)
                                .where(user_assessments: { user_id: current_user.id })
                                .includes(user_assessment: [:assessment])
    end
  end

  def show
    @user_result = UserResult.find(params[:id])
    @user_assessment = @user_result.user_assessment
    @question = @user_result.question
    @option = @user_result.option
  end

  private

  def authorize_admin
    unless current_user.admin? || current_user.user?
      redirect_to root_path, alert: 'Access denied.'
    end
  end
end
