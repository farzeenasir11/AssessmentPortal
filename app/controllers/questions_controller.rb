class QuestionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_assessment
  before_action :check_admin

  def new
    @project = Project.find(params[:project_id])
    @assessment = Assessment.find(params[:assessment_id])
    @question = @assessment.questions.new
    4.times { @question.options.build}
  end

  def create
    @project = Project.find(params[:project_id])
    @assessment = Assessment.find(params[:assessment_id])
    @question = @assessment.questions.new(question_params)
    if @question.save
      redirect_to project_assessment_path(@project, @assessment), notice: 'Question was created successfully.'
    else
      4.times { @question.options.build }
      render :new
    end
  end

  private

  def set_assessment
    @assessment = Assessment.find(params[:assessment_id])
  end

  def question_params
    params.require(:question).permit(:content,options_attributes: [:id, :content, :is_right, :destroy])
  end
 
  def check_admin
    redirect_to root_path, alert: 'Not authorized' unless current_user.admin?
  end
end
