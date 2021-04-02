class PagesController < ApplicationController

  skip_authorization_check

  helper_method :show_team

  def home
    @current_nav_identifier = :home
  end

  #redirect to modules or admin page based on privilege
  #admin/super admin => admin page
  #student/TA/module leader => modules page
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

  #load the modules again after choosing
  def modules
    @modules = ListModule.joins(:users).where("users.username = ?", current_user.username)
    session[:modules] = @modules
  end

  #get information about the team after choosing a module
  def show_team
    #Check if a module is chosen
    if params["module_choice"] != nil
      #get module name from module id
      @module_name = ListModule.find(params["module_choice"]["module_id"])
      session[:module_name] = @module_name

      #get the team name based on the current username and chosen module
      @team_info = Team.joins(:users, :list_module).where("users.username = ? AND list_modules.id = ?", current_user.username, params["module_choice"]["module_id"]).first
      
      #get info about the members in the current team 
      if @team_info != nil
        @team_members = User.joins(:teams).where("teams.name = ? AND teams.list_module_id = ?", @team_info.name, params["module_choice"]["module_id"])
      end

      #store team information and team members information in sessions for use in the view
      session[:team_info] = @team_info
      session[:team_members] = @team_members
    end
  end

end
