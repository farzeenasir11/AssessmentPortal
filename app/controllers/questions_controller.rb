class QuestionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_assessment
  before_action :check_admin

  def new
    @project = Project.find(params[:project_id])
    @assessment = Assessment.find(params[:assessment_id])
    @question = @assessment.questions.new
    4.times { @question.options.build}
    #@question.options.build # Build an empty option for the form
  end

  def create
    @project = Project.find(params[:project_id])
    @assessment = Assessment.find(params[:assessment_id])
    @question = @assessment.questions.new(question_params)
    if @question.save
      redirect_to project_assessment_path(@project, @assessment), notice: 'Question was created successfullu.'
      #redirect_to project_assessment_path(@assessment.project, @assessment), notice: 'Question was successfully created.'
    else
      4.times { @question.options.build } # Rebuild the options if save fails
      render :new
    end
  end

  private

  def set_assessment
    @assessment = Assessment.find(params[:assessment_id])
  end
  # def question_params
  #   params.require(:question).permit(:content, options_attributes: [:id, :content, :is_right, :_destroy])
  # end
  
  def question_params
    params.require(:question).permit(:content,options_attributes: [:id, :content, :is_right, :destroy])
  end
  
  # def create_options
  #   params[:option].each do |option|
  #     question.option.create(option.permit(:content, :is_right))
  #   end
  #end

  def check_admin
    redirect_to root_path, alert: 'Not authorized' unless current_user.admin?
  end
end
