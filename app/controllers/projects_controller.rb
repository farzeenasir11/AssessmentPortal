class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: %i[show edit update destroy]
  before_action :check_admin, only: [:new, :create, :edit, :update, :destroy]
  #after_action :verify_authorized

  def index
    #changins latest
    @q = Project.ransack(params[:q])
    @projects = @q.result
    #@projects = Project.all
    authorize @projects
  end

  def show
    #authorize @project
    @project = Project.find(params[:id])
    @assessments = @project.assessments
    @users = @project.users
  end

  def new
    @project = Project.new
    authorize @project
  end

  def create
    @project = Project.new(project_params)
    authorize @project
    if @project.save
      redirect_to @project, notice: 'Project was successfully created.'
    else
      render :new
    end
  end

  def edit
    authorize @project
  end

  def update
    authorize @project
    if @project.update(project_params)
      redirect_to @project, notice: 'Project was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @project = Project.find(params[:id])
    authorize @project
    @project.destroy
    redirect_to projects_url, notice: 'Project was successfully destroyed.'
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:project_name, :description, user_ids: [])
  end
end
