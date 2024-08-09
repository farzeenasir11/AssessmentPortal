class UserAssessmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user_assessment, only: [:show]

  def index
    @user_assessments = policy_scope(UserAssessment).where(user: current_user)
  end

  def show
    @user_assessment = current_user.user_assessments.find_by(id: params[:id])
    
    if @user_assessment.nil?
      redirect_to user_assessments_path, alert: 'Assessment not found or not accessible.'
      return
    end

    @user_results = @user_assessment.user_results.includes(:question, :option)
    authorize @user_assessment
  end

  def destroy
    @user_assessment = UserAssessment.find(params[:id])
    authorize @user_assessment
    @user_assessment.destroy
    redirect_to user_assessments_path, alert: 'Assessment successfully destroyed.'
  end

  private

  def set_user_assessment
    @user_assessment = UserAssessment.find(params[:id])
  end
end
