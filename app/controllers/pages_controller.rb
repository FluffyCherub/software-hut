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
      redirect_to admin_path
    else
      #redirect to the page for students/TA's/module leaders
      redirect_to modules_path
    end
  end

  #load the modules again after choosing
  def modules
    @modules = ListModule.joins(:users).where("users.username = ? AND user_list_modules.privilege = ?", 
                                              current_user.username,
                                              "student")

    #Check if a module is chosen
    if params["module_choice"] != nil
      module_id = params["module_choice"]["module_id"]

     
      @closest_date = FeedbackDate.get_closest_date(Time.now, module_id)
      @in_feedback_window = FeedbackDate.is_in_feedback_window(Time.now, module_id)
     

      #get module info from module id
      @module_info = ListModule.find(module_id)

      #get the team name based on the current username and chosen module
      @team_info = Team.joins(:users, :list_module)
                       .where("users.username = ? AND list_modules.id = ?", 
                               current_user.username, 
                               module_id).first
      
      #get info about the members in the current team 
      if @team_info != nil
        @team_members = User.joins(:teams)
                            .where("teams.name = ? AND teams.list_module_id = ?", 
                                    @team_info.name, 
                                    module_id)
      end

    end
  end


end
