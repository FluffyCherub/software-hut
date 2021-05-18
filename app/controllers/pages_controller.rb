#--------------------------------------------------------------------------
# Controller used for redirecting users to correct pages when logging in +
# basic student functionality
#--------------------------------------------------------------------------
# Authors: Dominik Laszczyk/Ling Lai
# Date: 23/03/2021
#--------------------------------------------------------------------------

class PagesController < ApplicationController

  skip_authorization_check

  #called to change the current ability(used for cancancan)
  def current_ability(module_privilege = "student")
    @current_ability ||= Ability.new(current_user, module_privilege)
  end

  def home
    @current_nav_identifier = :home
  end

  #redirect to modules or admin page based on privilege
  #admin/super admin => admin page
  #student/TA/module leader => modules page
  def index
    highest_privilege = User.highest_privilege(current_user.id)

    if highest_privilege == "admin"
      redirect_to admin_path()
    elsif highest_privilege == "module_leader"
      redirect_to admin_modules_path()
    elsif highest_privilege == "teaching_assistant"
      redirect_to admin_modules_path()
    elsif highest_privilege == "student"
      redirect_to student_profile_path()
    else
      render "errors/error_403"
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

      #get the closest feedback period(either the current or future)
      @closest_date = FeedbackDate.get_closest_date(Time.now, @module_id)

      #check if youre currently in a feedback period
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

        #get students that the current user has to give feedback on
        @in_team_without_current_user = User.joins(:teams)
                                            .where("teams.id = ? AND 
                                                    users.id NOT IN (?)",
                                                    @team_info.id,
                                                    current_user.id
                                                    )

        if @closest_date != nil
        @is_feedback_completed = PeerFeedback.check_feedback_completion(@in_team_without_current_user, current_user.username, @closest_date.id)
        else
          @is_feedback_completed = false
        end
      end

      if params['commit'] == "Select"
        redirect_to modules_path(:module_id => @module_id)
      end
    end
  end

  def student_groups_join
    #checking if the current user has access to this page
    current_ability(User.get_module_privilege(params[:module_id], current_user.id))
    authorize! :manage, :student_groups_join

    if params['join_team_button'] == "join_team"
      UserTeam.put_student_in_team(current_user.id, params['team_id'])
      redirect_to student_profile_path(:module_id => params[:module_id])
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

  def student_profile_feedback_old
    #checking if the current user has access to this page
    authorize! :manage, :student_profile_feedback_old

    #getting modules wiith only inactive teams fo the current user
    @inactive_modules = ListModule.joins(:teams, :users)
                                  .where("users.username = ? AND teams.status = ?",
                                          current_user.username,
                                          "inactive")
                                  .group(:id)


    render layout: 'extra_wide_left'
  end

  def feedback_old_show
    selected_team_id = params['selected_team_id']

    #get the feedback averages for the selected team feedback
    feedback_data = PeerFeedback.get_average_feedback_data(current_user.username, selected_team_id.to_i)

    @average_feedback_data = feedback_data[0]
    @num_of_periods = feedback_data[1]

    #rounding average feeback data
    for i in 0...@average_feedback_data.length
      for j in 0...@average_feedback_data[i].length
        if !@average_feedback_data[i][j].nan?
          @average_feedback_data[i][j] = @average_feedback_data[i][j].round()
        end
      end
    end

    respond_to do |format|
      format.js {render layout: false}
    end
  end

  def student_profile_docs_old
    #checking if the current user has access to this page
    authorize! :manage, :student_profile_docs_old

    #modules with at least one inactive team inside of them for the current user
    @academic_years = ListModule.joins(:users)
                                .where("users.username = ?",  
                                        current_user.username)
                                .group(:id)
                                .select(:years).distinct

    render layout: 'extra_wide_left'
  end

  def student_profile
    #checking if the current user has access to this page
    authorize! :manage, :student_profile


    @full_name = current_user.givenname + " " +  current_user.sn
    @department = current_user.ou
    @username = current_user.username
    @email = current_user.email

    @active_modules = ListModule.joins(:users, :teams)
                                .where("users.username = ? AND 
                                        user_list_modules.privilege = ? AND
                                        teams.status = ?", 
                                        current_user.username,
                                        "student",
                                        "active"
                                          )
                                .group(:id)

  end

  def student_profile_select_module
    selected_module_id = params['module_id']

    #get module info from module id
    @module_info = ListModule.find(selected_module_id)

    #check if youre currently in a feedback period
    @in_feedback_window = FeedbackDate.is_in_feedback_window(Time.now, @module_info.id)

    #get the team info based on the current username and chosen module
    @team_info = Team.joins(:users, :list_module)
                      .where("users.username = ? AND list_modules.id = ? AND teams.status = ?", 
                              current_user.username, 
                              selected_module_id,
                              "active").first

    
    if @team_info != nil

      #get the feedback averages for the selected team feedback
      feedback_data = PeerFeedback.get_average_feedback_data(current_user.username, @team_info.id)

      @average_feedback_data = feedback_data[0]
      @num_of_periods = feedback_data[1]
      @average_overall =  feedback_data[2]
      @team_members_without_current_user = feedback_data[3]
      @team_members = feedback_data[4]

      #rounding average feeback data
      for i in 0...@average_feedback_data.length
        for j in 0...@average_feedback_data[i].length
          if !@average_feedback_data[i][j].nan?
            @average_feedback_data[i][j] = @average_feedback_data[i][j].round()
          end
        end
      end

      #CLOSEST DATES SECTION-------------------------------------------------------
      #get the closest feedback period(either the current or future)
      @closest_date = FeedbackDate.get_closest_date(Time.now, @module_info.id)
    
      if @closest_date != nil
        @f_period_start_date = @closest_date.start_date.strftime("%I:%M %p %d/%m/%Y")
        @f_period_end_date = @closest_date.end_date.strftime("%I:%M %p %d/%m/%Y")

        if @in_feedback_window == true
          #check if feedback is completed and submitted 
          @is_feedback_completed = PeerFeedback.check_feedback_completion(@team_members_without_current_user, current_user.username, @closest_date.id)
        end
      end

    else
      @unapproved_team_info = Team.joins(:users, :list_module)
                                  .where("users.username = ? AND list_modules.id = ? AND teams.status = ?", 
                                          current_user.username, 
                                          selected_module_id,
                                          "waiting_for_approval").first
    end

      
    respond_to do |format|
      format.js {render layout: false}
    end
  end

end
