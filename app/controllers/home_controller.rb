class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    # if user_signed_in?
    #   @projects = current_user.projects # or `current_user.project` if a user has one project
    # end
    if user_signed_in? && current_user.admin?
      @projects = Project.all
    end
  end
end
