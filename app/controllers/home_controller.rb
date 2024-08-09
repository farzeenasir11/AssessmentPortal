class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    if user_signed_in? && current_user.admin?
      @projects = Project.all
    end
  end
end
