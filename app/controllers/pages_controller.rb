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

  def student_groups_join
    authorize! :manage, :admin_modules_groups

    #getting a list of ta's and modules leaders for assigning problems
    @ta_and_mod_lead = []
    users_in_module = ListModule.users_in_module(params['module_id'])
    for i in 0..(users_in_module.length-1) 
      current_user_privilege = ListModule.privilege_for_module(users_in_module[i].username, params['module_id'])
      
      
      current_user_names = users_in_module[i].givenname + " " + users_in_module[i].sn + " - " + users_in_module[i].username
      if current_user_privilege.include?("teaching_assistant") || current_user_privilege.include?("module_leader")
        @ta_and_mod_lead.append(current_user_names)
      end
    end

    #assigning and solving problems
    if params['problem_form'] != nil
      problem_id = params['problem_form']['form_problem_id']
      if params['assign_button'] == "Assign"
        user_to_assign = params['problem_form']['assign_list'].split(" ")[-1]
        
        Problem.assign(user_to_assign, problem_id)
        Problem.change_status(problem_id, "assigned")
      end

      if params['solve_button'] == "Mark as solved"
        if Problem.is_assigned(problem_id) == false
          Problem.assign(current_user.username, problem_id)
        end

        Problem.solve(current_user.username, problem_id)
        Problem.change_status(problem_id, "solved")
      end

      redirect_back(fallback_location: root_path)
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
    @groups_for_module = Team.left_outer_joins(:users).where("teams.list_module_id = ? AND
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
                                                    ).group(:id).order(search_type)
    
    #getting the total number of problems
    @num_of_problems = 0
    for i in 0..(@groups_for_module.length-1)
      num_current_problems = Problem.where(team_id: @groups_for_module[i].id).length
      @num_of_problems = @num_of_problems + num_current_problems
    end

    if params['search_button'] == "Search" || params['search_form'] != nil
      mod_id = params['search_form']['form_module_id']
      redirect_to admin_modules_groups_path(module_id: mod_id, search_input: params['search_form']['search_input'], search_type: params['search_form']['search_type'])
    end

    #removing a student from a group
    if params['remove_student_button'] == "remove_student"
     
      user_to_remove = UserTeam.where("user_id = ? AND team_id =?",
                                       params['student_remove_id'],
                                       params['team_id'])

      if user_to_remove != nil
        user_to_remove.first.destroy
      end

      redirect_back(fallback_location: root_path)
    end

  end

end
