class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    if params[:project_id]
      @project = Project.find(params[:project_id])
      @users = @project.users
    elsif params[:assessment_id]
      @assessment = Assessment.find(params[:assessment_id])
      @users = @assessment.users
    else
      @users = User.all
    end
  end
end
