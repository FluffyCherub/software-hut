class PagesController < ApplicationController

  skip_authorization_check

  helper_method :show_team

  def home
    @current_nav_identifier = :home
  end

  def index
    if current_user.admin?
      #redirect to the admin/super admin page
      redirect_to "/admin_page"
    else
      @modules = ListModule.joins(:users).where("users.username = ?", current_user.username)
      session[:modules] = @modules
      
      #redirect to the page for students/TA's/module leaders
      redirect_to "/modules"
    end
  end

  def modules
    if current_user.admin?
      #redirect to the admin/super admin page
      redirect_to "/admin_page"
    else
      @modules = ListModule.joins(:users).where("users.username = ?", current_user.username)
      session[:modules] = @modules
    end
  end

  def show_team
    #Check if module choice is nil. Otherwise crash
    if params["module_choice"] != nil
      puts params["module_choice"]["module_name"]
    end
  end

end
