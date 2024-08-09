class UserProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project
  #before_action :set_user_project, only: %i[destroy]
  after_action :verify_authorized

  def index
    #@user_projects = UserProject.all
    @user_projects = @project.users
    authorize @user_projects
  end

  def new
    @user_project = UserProject.new
    authorize @user_project
  end

  def create
    @user_project = UserProject.new(user_project_params)
    authorize @user_project
    if @user_project.save
      redirect_to user_projects_path, notice: 'User was successfully assigned to the project.'
    else
      render :new
    end
  end

  def destroy
    authorize @user_project
    @user_project.destroy
    redirect_to user_projects_path, notice: 'User was successfully removed from the project.'
  end

  private
  def set_project
    @project = Project.find(params[:project_id])
  end
  
  def set_user_project
    @user_project = UserProject.find(params[:id])
  end

  def user_project_params
    params.require(:user_project).permit(:user_id, :project_id, :assigned_on)
  end
end
