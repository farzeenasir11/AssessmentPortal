class AssessmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project
  before_action :set_assessment, only: %i[show edit update destroy attempt submit_attempt assign_user]
  before_action :check_admin, only: [:new, :create, :edit, :update, :destroy, :assign_user]
  after_action :verify_authorized, except: [:index]

  def index
    @assessments = policy_scope(@project.assessments)
  end

  def assign_user
    authorize @assessment, :assign_user?
    if request.post?
      user_ids = params[:user_ids]
      user_ids.each do |user_id|
        user = User.find(user_id)
        @assessment.users << user unless @assessment.users.include?(user)
      end
      redirect_to project_assessment_path(@project, @assessment), notice: 'Users assigned successfully.'
    else
      @users_to_assign = User.all - @assessment.users
    end
  end

  def show
    @assessment = Assessment.find(params[:id])
    authorize @assessment
    @user_assessment = UserAssessment.find_by(user: current_user, assessment: @assessment)
    @score = @user_assessment&.calculate_score || 0
  end

  def attempt
    authorize @assessment, :attempt?
    @questions = @assessment.questions.includes(:options)
  end

  def submit_attempt
    @assessment = Assessment.find(params[:id])
    @user_assessment = UserAssessment.find_or_create_by(user: current_user, assessment: @assessment)

    authorize @assessment, :submit_attempt?
    
    params[:answers].each do |question_id, answer_id|
      option = Option.find(answer_id)
      correct = option.is_right
      @user_assessment.user_results.create(
        question_id: question_id,
        option_id: answer_id,
        correct: correct
      )
    end
    redirect_to user_assessment_path(@user_assessment), notice: 'Assessment submitted successfully.'
  end

  def new
    @project = Project.find(params[:project_id])
    @assessment = @project.assessments.build
    authorize @assessment
  end

  def create
    @assessment = @project.assessments.build(assessment_params)
    authorize @assessment
    if @assessment.save
      redirect_to project_assessment_path(@project, @assessment), notice: 'Assessment was successfully created.'
    else
      render :new
    end
  end

  def edit
    authorize @assessment
  end

  def update
    authorize @assessment
    if @assessment.update(assessment_params)
      redirect_to project_assessment_path(@project, @assessment), notice: 'Assessment was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    authorize @assessment
    @assessment.destroy
    redirect_to assessments_url, notice: 'Assessment was successfully destroyed.'
  end

  private
  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_assessment
    @assessment = Assessment.find(params[:id])
  end

  def assessment_params
    params.require(:assessment).permit(:title, :description, :project_id)
  end
end

