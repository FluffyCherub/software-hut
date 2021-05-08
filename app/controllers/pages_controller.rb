#--------------------------------------------------------------------------
# Controller used for redirecting users to correct pages when logging in +
# basic student functionality
#--------------------------------------------------------------------------
# Authors: Dominik Laszczyk/Ling Lai
# Date: 23/03/2021
#--------------------------------------------------------------------------

class PagesController < ApplicationController

  skip_authorization_check

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
      #redirect_to modules_path
      redirect_to student_profile_path
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
    authorize! :manage, :admin_modules_groups

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
    render layout: 'extra_wide_left'
  end

  def student_profile_docs_old
    render layout: 'extra_wide_left'
  end

  def student_profile
    @full_name = current_user.givenname + " " +  current_user.sn
    @department = current_user.ou
    @username = current_user.username
    @email = current_user.email

    @active_modules = ListModule.joins(:users)
                         .where("users.username = ? AND user_list_modules.privilege = ?", 
                                 current_user.username,
                                 "student")

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
      #get all team members for the selected team
      @team_members = User.joins(:teams)
                          .where("teams.id = ?",
                                  @team_info.id)

      #get all team members without the current user
      @team_members_without_current_user = User.joins(:teams)
                                                .where("teams.id = ? AND
                                                        users.id != ?",
                                                        @team_info.id,
                                                        current_user.id)

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

      #store team members usernames in an array
      teams_members_usernames = @team_members_without_current_user.pluck(:username)

      #get feedback periods fot this team
      f_periods = FeedbackDate.joins(:teams).where("teams.id = ?", @team_info.id)
      @num_of_periods = f_periods.length

      #array for storing all the feedback averages
      width = f_periods.length
      height = 7
      @average_feedback_data = Array.new(height){Array.new(width)}

      #average of averages of all periods
      average_for_all_periods = Array.new(f_periods.length)

      #get feedback data for every period and calculate the averages
      for k in 0...f_periods.length

        current_feedback_data = PeerFeedback.where("created_for = ? AND
                                                    created_by IN (?) AND
                                                    feedback_date_id = ?",
                                                    current_user.username,
                                                    teams_members_usernames,
                                                    f_periods[k].id)
                                            .pluck(:attendance, :attitude, :qac, :communication, :collaboration, :leadership, :ethics)

        #calculating average data for every on of the seven criteria
        for z in 0...7
          data_for_one_criteria = current_feedback_data.collect {|ind| ind[z]}
          average_data_for_one_criteria = data_for_one_criteria.inject{ |sum, el| sum + el }.to_f / data_for_one_criteria.size

          @average_feedback_data[z][k] = average_data_for_one_criteria
        end

      end

      #loop through the averages and get the ultimate average
      for z in 0...f_periods.length
        data_for_one_criteria = @average_feedback_data.collect {|ind| ind[z]}
        average_data_for_one_criteria = data_for_one_criteria.inject{ |sum, el| sum + el }.to_f / data_for_one_criteria.size

        average_for_all_periods[z] = (average_data_for_one_criteria)
      end
      
      #adding the average of averages to the other averages
      @average_feedback_data.prepend(average_for_all_periods)

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
