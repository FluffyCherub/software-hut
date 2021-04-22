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
    if params["module_choice"] != nil || params['module_id'] != nil

      if params["module_choice"] == nil
        @module_id = params["module_id"]
      else
        @module_id = params["module_choice"]["module_id"]
      end

     
      @closest_date = FeedbackDate.get_closest_date(Time.now, @module_id)
      @in_feedback_window = FeedbackDate.is_in_feedback_window(Time.now, @module_id)
     

      #get module info from module id
      @module_info = ListModule.find(@module_id)

      #get the team name based on the current username and chosen module
      @team_info = Team.joins(:users, :list_module)
                       .where("users.username = ? AND list_modules.id = ?", 
                               current_user.username, 
                               @module_id).first
      
      #get info about the members in the current team 
      if @team_info != nil
        @team_members = User.joins(:teams)
                            .where("teams.name = ? AND teams.list_module_id = ?", 
                                    @team_info.name, 
                                    @module_id)
      end

      if params['commit'] == "Select"
        redirect_to modules_path(:module_id => @module_id)
      end
    end
  end

  def student_groups_join
    authorize! :manage, :admin_modules_groups

    if params['join_team_button'] == "join_team"
      UserTeam.put_student_in_team(current_user.id, params['team_id'])
      redirect_to modules_path(:module_id => params[:module_id])
    end
    
    #setting the search input parameter to display the correct teams
    if params['search_button'] == "Search" || params['search_form']!= nil
      @saved_input = params['search_form']['search_input']
      search_input = params['search_form']['search_input']
      search_type = params['search_form']['search_type']
    elsif params['search_input'] != nil
      @saved_input = params['search_input']
      search_input = params['search_input']
      search_type = params['search_type']
    else
      @saved_input = ""
      search_input = ""
      search_type = "Default - A to Z"
    end

    
    #remembering the search input and sorting by the selected search type
    if search_type == "Team size - Low to High"
      @selected_type = "Team size - Low to High"
      search_type = 'count(user_id)'
    elsif search_type == "Default - A to Z"
      @selected_type = "Default - A to Z"
      search_type = 'SUBSTRING(name FROM 1 FOR 4), CAST(SUBSTRING(name FROM 6) AS INTEGER)'
    elsif search_type == "Team size - High to Low"
      @selected_type = "Team size - High to Low"
      search_type = 'count(user_id) DESC'
    elsif search_type == "Topic - A to Z"
      @selected_type = "Topic - A to Z"
      search_type = 'topic'
    end

    #getting teams for the current search input
    @groups_for_module = Team.left_outer_joins(:users)
                             .where("teams.list_module_id = ? AND
                                      (users.givenname LIKE ? OR
                                      users.sn LIKE ? OR
                                      users.email LIKE ? OR
                                      teams.name LIKE ? OR 
                                      teams.topic LIKE ?)",
                                      params[:module_id],
                                      "%" + search_input + "%",
                                      "%" + search_input + "%",
                                      "%" + search_input + "%",
                                      "%" + search_input + "%",
                                      "%" + search_input + "%"
                                      )
                                      .group(:id)
                                      .order(search_type)
    

    if params['search_button'] == "Search" || params['search_form'] != nil
      mod_id = params['search_form']['form_module_id']
      
      redirect_to student_groups_path(module_id: mod_id, search_input: params['search_form']['search_input'], search_type: params['search_form']['search_type'])
    end

    

  end

end
