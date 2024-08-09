class AssessmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project
  before_action :set_assessment, only: %i[show edit update destroy attempt submit_attempt assign_user]
  before_action :check_admin, only: [:new, :create, :edit, :update, :destroy, :assign_user]
  after_action :verify_authorized, except: [:index]

  def index
    #@assessments = Assessment.all
    @assessments = policy_scope(@project.assessments)
    #authorize @assessments
    # @assessments = @project.assessments
    # authorize @assessments
  end

  #assigning the user to a specific assessement
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
    # authorize @assessment, :assign_user?
    # if request.post?
    #   user = User.find(params[:user_id])
    #   @assessment.users << user unless @assessment.users.include?(user)
    #   redirect_to project_assessment_path(@project, @assessment), notice: 'User assigned successfully.'
    # else
    #   @users = User.all - @assessment.users
    # end
  end

  def show
    # @assessment = Assessment.find(params[:id])
    # authorize @assessment
    # @user_assessment = @project.user_assessments.find_by(assessment: @assessment, user: current_user)
    # @score = @user_assessment&.calculate_score || 0
    #latest
    @assessment = Assessment.find(params[:id])
    authorize @assessment
    @user_assessment = UserAssessment.find_by(user: current_user, assessment: @assessment)
    @score = @user_assessment&.calculate_score || 0
    #old
    # if @user_assessment.present?
    #   @score = @user_assessment.calculate_score
    #   #Rails.logger.debug { "Calculated score: #{@score}" }
    # else
    #   @score = 0
    # end
    # @user_assessment = UserAssessment.find_by(user: current_user, assessment: @assessment)
    
    # authorize @assessment
    # @user_assessment = UserAssessment.find_by(user: current_user, assessment: @assessment)
    # @score = @user_assessment.calculate_score if @user_assessment.present?
  end
  # to be chnaged yet****************
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

    # Example logic for creating UserResult records
    # params[:answers].each do |question_id, answer_id|
    #   option = Option.find(answer_id)
    #   correct = option.is_right

    #   @user_assessment.user_results.create(
    #     question_id: question_id,
    #     option_id: answer_id,
    #     correct: correct
    #   )
    # end
    # redirect_to user_assessment_path(user_assessment), notice: 'Assessment submitted successfully.'
    # Redirect or render as needed
  #end
    # authorize @assessment, :submit_attempt?
    # user_assessment = current_user.user_assessments.create(assessment: @assessment)
  
    # params[:answers].each do |question_id, option_id|
    #   UserResult.create(
    #     user_assessment: user_assessment,
    #     question_id: question_id,
    #     option_id: option_id
    #   )
    # end
  
  #   redirect_to user_assessment_path(user_assessment), notice: 'Assessment submitted successfully.'
  # end

  def new
    # @assessment = Assessment.new
    @project = Project.find(params[:project_id])
    @assessment = @project.assessments.build
    authorize @assessment
  end

  def create
    #@assessment = Assessment.new(assessment_params)
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
    #@assessment = @project.assessments.find(params[:id])
    @assessment = Assessment.find(params[:id])
  end

  def assessment_params
    params.require(:assessment).permit(:title, :description, :project_id)
  end

  # def calculate_score
  #   correct_answers_count = user_results.where(correct: true).count
  #   total_questions = user_results.count

  #   score_percentage = total_questions.zero? ? 0 : (correct_answers_count.to_f / total_questions) * 100

  #   score_percentage
  # end
end

