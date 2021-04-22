class AdminController < ApplicationController
  require 'csv'
  require 'date'
  require 'active_support/core_ext'
  
  def current_ability(module_privilege = "module_leader")
    @current_ability ||= Ability.new(current_user, module_privilege)
  end

  def admin_page
    authorize! :manage, :admin_page

    #redirect to different admin subpages based on the button pressed
    if params['manage_privileges'] == "Manage Privileges"
      redirect_to "/admin/privileges"
    elsif params['manage_modules'] == "Manage Modules"
      redirect_to "/admin/modules"
    end
  end

  def admin_privileges
    authorize! :manage, :admin_privileges
    
    #if the search button was pressed pass the users that match search input
    if params['search_button'] == 'Search'
      search_param = "%" + params['search_form']['search_input'] + "%"
      @users_list = User.where("username LIKE ? OR
                               givenname LIKE ? OR
                               sn LIKE ?", search_param, search_param, search_param)
    else
      @users_list = User.all.order(:givenname, :sn)
    end

    if params['privilege_form'] != nil
      #get the user to switch his privilege
      chosen_user = User.find_by(username: params['privilege_form']['form_username'])

      #change the chosen users system privilege based on which button was pressed
      if params['suspend_button'] == "Suspend"
        chosen_user.update(:suspended => true)
      elsif params['unsuspend_button'] == "Unsuspend"
        chosen_user.update(:suspended => false)
      elsif params['make_admin_button'] == "Make Admin"
        chosen_user.update(:admin => true)
      elsif params['remove_admin_button'] == "Remove Admin"
        chosen_user.update(:admin => false)
      end
    end

  end

  def admin_modules
    authorize! :manage, :admin_modules

    #find the accroding entries in modules table based on search input
    if params['search_button'] == "Search"
      search_input_modules = ListModule.where("years LIKE ? OR name LIKE ? OR code LIKE ? OR description LIKE ? OR semester LIKE ?", 
                                                "%" + params['search_form']['search_input'] + "%",
                                                "%" + params['search_form']['search_input'] + "%",
                                                "%" + params['search_form']['search_input'] + "%",
                                                "%" + params['search_form']['search_input'] + "%",
                                                "%" + params['search_form']['search_input'] + "%")
    end

    #getting all the distinct academic years from list of modules
    years = []
    years_temp = []
    if params['search_button'] == "Search"
      years_temp = search_input_modules.select(:years).distinct
    else
      years_temp = ListModule.select(:years).distinct
    end

    #creating an array of distinct academic years
    for i in 0..(years_temp.length-1)
      years.append(years_temp[i].years)
    end
    
    #sorting the years in descending order(from the most recent one to the oldest)
    years = years.sort_by { |t| t[5, 8] }.reverse

    #creating a 2d array of modules based on academic years(and search input)
    @modules_by_year = []
    for i in 0..(years.length-1)
      current_year_modules = []
      if params['search_button'] == "Search"
        current_year_modules = search_input_modules.where(years: years[i]).order(:code)
      else
        current_year_modules = ListModule.where(years: years[i]).order(:code)
      end
      @modules_by_year.append(current_year_modules)
    end

    #get the number of modules which are displayed on the website
    @num_of_modules = 0
    if params['search_button'] == "Search"
      @num_of_modules = @modules_by_year.flatten.length
    else
      @num_of_modules = ListModule.all.length
    end
    
  end

  def admin_modules_preview
    current_ability(User.get_module_privilege(params[:module_id], current_user.id))
    authorize! :manage, :admin_modules_preview

    #getting the module information about the currently displayed module
    @module_info = ListModule.where("id = ?", params[:module_id]).first
    
    #getting the module leader of the currently displayed module
    @module_leaders = User.joins(:list_modules).where("user_list_modules.privilege = ? AND
                                                      list_modules.id = ?",
                                                      "module_leader",
                                                      params[:module_id]).order(:givenname, :sn)

    #getting the teaching assistants of the currently displayed module
    @teaching_assistants = User.joins(:list_modules).where("user_list_modules.privilege LIKE ? AND
                                                            list_modules.id = ?",
                                                            "%teaching_assistant%",
                                                            params[:module_id]).order(:givenname, :sn)

    #setting the search input parameter to display the correct users
    if params['search_button'] == "Search"
      search_input = params['search_form']['search_input']
    elsif params['search_input'] != nil
      search_input = params['search_input']
    else
      search_input = ""
    end
    
    #getting users for the correct module and search input
    @current_module_users = User.joins(:list_modules)
                                .where("list_modules.id = ? AND 
                                          (users.username LIKE ? OR
                                          users.givenname LIKE ? OR 
                                          users.sn LIKE ? OR 
                                          users.email LIKE ? OR 
                                          user_list_modules.privilege LIKE ?)", 
                                            params[:module_id],
                                            "%" + search_input + "%",
                                            "%" + search_input + "%",
                                            "%" + search_input + "%",
                                            "%" + search_input + "%",
                                            "%" + search_input + "%") 
                                .order(:givenname, :sn)

    if params['search_button'] == "Search"
      mod_id = params['search_form']['form_module_id']
      redirect_to admin_modules_preview_path(module_id: mod_id, search_input: params['search_form']['search_input'])
    end


    if params['add_user_button'] == "add_user"
      add_username = params['add_username']
      add_email = params['add_email']
      add_first_name = params['add_first_name']
      add_last_name = params['add_last_name']

      #check if all the fields were provided
      if add_username.length>0 && add_email.length>0 && add_first_name.length>0 && add_last_name.length>0 && add_email.include?('@') == false

        #check if user with this username doesn't exist in the system
        check_user_exist = User.where("username = ?",
                                      add_username
                                      )

        user_to_add = ''
        #if user does not exist, create him
        if check_user_exist.length == 0 && add_username != nil
          user_to_add = User.create(username: add_username,
                                    email: add_email,
                                    givenname: add_first_name,
                                    sn: add_last_name)
        else
          user_to_add = User.where("username = ?",
                                    add_username
                                    ).first
        end

        #add the user to the module if he is not already in it
        check_user_in_module = User.joins(:list_modules).where("users.username = ? AND list_modules.id = ?",
                                                                add_username,
                                                                params[:module_id])

        if check_user_in_module.length == 0
          UserListModule.find_or_create_by(list_module_id: params[:module_id],
                                          user_id: user_to_add.id,
                                          privilege: "student")
        elsif ListModule.privilege_for_module(add_username, params[:module_id]) == "suspended"
          get_privilege = UserListModule.where(list_module_id: params[:module_id],
                                                user_id: user_to_add.id
                                                )

          get_privilege.update(privilege: "student")
        end
      else
        #popup one of the values was not provided, so user not created
      end
    end


    #taking a csv file and adding students to modules based on it
    if params['commit'] == "Upload"
      ListModule.import(params['file'], params['module_id'])
    end
  
  end

  def admin_modules_create
    authorize! :manage, :admin_modules_create

    #generating academic years based on current year
    @generated_years = ListModule.generate_years(Time.now.year, 5)
    
    if params['create_module_button'] == "Create"
      #getting all the variables needed to create a module
      module_name = params['module_create_form']['module_name']
      module_code = params['module_create_form']['module_code']
      module_description = params['module_create_form']['module_description']
      semester = params['module_create_form']['semester']
      years = params['module_create_form']['years']
      level = params['module_create_form']['level']

      if module_name != nil && module_code != nil && module_description != nil && semester != nil && years != nil
        #checking if a module with this name and year is in the system
        module_check = ListModule.where("name = ? AND years = ?", 
                                        module_name,
                                        years)

        if module_check.length == 0
          #creating a module with the given parameters
          created_module = ListModule.find_or_create_by(name: module_name,
                                                        code: module_code,
                                                        description: module_description,
                                                        semester: semester,
                                                        years: years,
                                                        created_by: current_user.username,
                                                        level: level
                                                        )
        
          #making the current user module leader if he checked the checkbox
          if params['module_create_form']['module_leader'] == "checked-value" && created_module != nil
            add_mod_leader = UserListModule.create(list_module_id: created_module.id,
                                                  user_id: current_user.id,
                                                  privilege: "module_leader")
          end
        end
      else
        #popup that a field was empty
      end
    end
    
  end

  def admin_modules_edit
    authorize! :manage, :admin_modules_edit

    if params['edit_module_button'] == "Edit"
      module_name = params['module_edit_form']['module_name']
      module_code = params['module_edit_form']['module_code']
      years = params['module_edit_form']['years']
      module_description = params['module_edit_form']['module_description']
      semester = params['module_edit_form']['semester']
      form_module_id = params['module_edit_form']['form_module_id']
      level = params['module_edit_form']['level']

      if module_name.nil? == false && module_code.nil? == false && years.nil? == false && module_description.nil? == false && semester.nil? == false
        #checking if a module with this name and year is in the system
        module_check = ListModule.where("name = ? AND years = ? AND id != ?", 
                                        module_name,
                                        years,
                                        form_module_id)

        if module_check.length == 0
          current_module = ListModule.find_by(id: form_module_id)
          current_module.update(name: module_name,
                                code: module_code,
                                description: module_description,
                                semester: semester,
                                years: years,
                                level: level)
          
        end

      else
        #popu didnt edit because field was empty
      end

      redirect_to admin_modules_preview_path(module_id: form_module_id)
    elsif params['clone_module_button'] == "Clone"
      module_name = params['module_edit_form']['module_name']
      module_code = params['module_edit_form']['module_code']
      years = params['module_edit_form']['years']
      module_description = params['module_edit_form']['module_description']
      semester = params['module_edit_form']['semester']
      form_module_id = params['module_edit_form']['form_module_id']
      level = params['module_edit_form']['level']

      if module_name.nil? == false && module_code.nil? == false && years.nil? == false && module_description.nil? == false && semester.nil? == false
        #checking if a module with this name,code,semester and year is in the system
        module_check = ListModule.where("name = ? AND years = ? AND code = ? AND semester = ?", 
                                        module_name,
                                        years,
                                        module_code,
                                        semester,
                                        level
                                        )

        if module_check.length == 0
          cloned_module = ListModule.find_or_create_by(name: module_name,
                                                      code: module_code,
                                                      description: module_description,
                                                      semester: semester,
                                                      years: years,
                                                      created_by: current_user.username,
                                                      level: level)
        
          #adding module leaders to the cloned module
          if params['module_edit_form']['check_box_ml'] == "checked-value"
            module_leaders = User.joins(:list_modules).where("list_modules.id = ? AND user_list_modules.privilege = ?",
                                                              form_module_id,
                                                              "module_leader")

            for i in 0..(module_leaders.length-1)
              UserListModule.create(user_id: module_leaders[i].id,
                                    list_module_id: cloned_module.id,
                                    privilege: "module_leader")
            end
          end

          if params['module_edit_form']['check_box_ta'] == "checked-value"
            teaching_assistants = User.joins(:list_modules).where("list_modules.id = ? AND user_list_modules.privilege LIKE ?",
                                                                  form_module_id,
                                                                  "%teaching_assistant%")
          

            for i in 0..(teaching_assistants.length-1)
              UserListModule.create(user_id: teaching_assistants[i].id,
                                    list_module_id: cloned_module.id,
                                    privilege: User.get_module_privilege(form_module_id, teaching_assistants[i].id))
          
            end
          end
        end
      else
        #popup didnt clone because field was empty
      end

      redirect_to admin_modules_preview_path(module_id: form_module_id)
    else
      #getting information about the selected module
      @module_info = ListModule.where(id: params['module_id']).first
      
      #generating academic years based on current year
      @generated_years = ListModule.generate_years(Time.now.year, 5)

      #if the years of the module arent generated append them to the array
      if @generated_years.include?(@module_info.years) == false
        @generated_years.append(@module_info.years)
      end

      #sort years
      @generated_years = @generated_years.sort_by { |t| t[5, 8] }
    end
    
  end

  def admin_modules_groups
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

  def admin_modules_privilege
    authorize! :manage, :admin_modules_privilege

    @saved_privilege = UserListModule.where(list_module_id: params['module_id'],
                                            user_id: params['user_id']).first.privilege

    if params['save_button'] == "Save"
      privilege_to_update = UserListModule.where(list_module_id: params['module_id'],
                                                   user_id: params['user_id'])

      if params['options1'] == "on"
        #student
        privilege_to_update.update(privilege: "student")
        
      elsif params['options2'] == "on"
        #teaching assitant
        priv_1 = params['privilege_1']
        priv_2 = params['privilege_2']
        priv_3 = params['privilege_3']
        priv_4 = params['privilege_4']
        ta_type = ""
        
        if priv_1 == "on" && priv_2.nil?    && priv_3.nil?    && priv_4.nil?    then ta_type = "teaching_assistant_1"  end
        if priv_1.nil?    && priv_2 == "on" && priv_3.nil?    && priv_4.nil?    then ta_type = "teaching_assistant_2"  end
        if priv_1.nil?    && priv_2.nil?    && priv_3 == "on" && priv_4.nil?    then ta_type = "teaching_assistant_3"  end
        if priv_1.nil?    && priv_2.nil?    && priv_3.nil?    && priv_4 == "on" then ta_type = "teaching_assistant_4"  end
        if priv_1 == "on" && priv_2 == "on" && priv_3.nil?    && priv_4.nil?    then ta_type = "teaching_assistant_5"  end
        if priv_1.nil?    && priv_2 == "on" && priv_3 == "on" && priv_4.nil?    then ta_type = "teaching_assistant_6"  end
        if priv_1.nil?    && priv_2.nil?    && priv_3 == "on" && priv_4 == "on" then ta_type = "teaching_assistant_7"  end
        if priv_1 == "on" && priv_2.nil?    && priv_3 == "on" && priv_4.nil?    then ta_type = "teaching_assistant_8"  end
        if priv_1 == "on" && priv_2.nil?    && priv_3.nil?    && priv_4 == "on" then ta_type = "teaching_assistant_9"  end
        if priv_1.nil?    && priv_2 == "on" && priv_3.nil?    && priv_4 == "on" then ta_type = "teaching_assistant_10" end
        if priv_1 == "on" && priv_2 == "on" && priv_3 == "on" && priv_4.nil?    then ta_type = "teaching_assistant_11" end
        if priv_1.nil?    && priv_2 == "on" && priv_3 == "on" && priv_4 == "on" then ta_type = "teaching_assistant_12" end
        if priv_1 == "on" && priv_2.nil?    && priv_3 == "on" && priv_4 == "on" then ta_type = "teaching_assistant_13" end
        if priv_1 == "on" && priv_2 == "on" && priv_3.nil?    && priv_4 == "on" then ta_type = "teaching_assistant_14" end
        if priv_1 == "on" && priv_2 == "on" && priv_3 == "on" && priv_4 == "on" then ta_type = "teaching_assistant_15" end
        if priv_1.nil?    && priv_2.nil?    && priv_3.nil?    && priv_4.nil?    then ta_type = "teaching_assistant_16" end  
                                             
        privilege_to_update.update(privilege: ta_type)

      elsif params['options3'] == "on"
        #module_leader
        privilege_to_update.update(privilege: "module_leader")
        
      end

      @close_window = "true"

    end

    render layout: 'empty'
  end

  def admin_modules_groups_preview
    authorize! :manage, :admin_modules_groups_preview

    #setting the module and team ids to the correct values
    module_id = params['module_id']
    team_id = params['team_id']
    if params['module_id'] == nil && params['problem_form'] == nil
      module_id = params['search_form']['form_module_id']
    elsif params['module_id'] == nil && params['search_form'] == nil
      module_id = params['problem_form']['form_module_id']
    end
    if params['team_id'] == nil && params['problem_form'] == nil
      team_id = params['search_form']['form_team_id']
    elsif params['team_id'] == nil && params['search_form'] == nil
      team_id = params['problem_form']['form_team_id']
    end

    #get info about the selected team
    @selected_group_team = Team.where(id: team_id).first
    @current_team_size = Team.get_current_team_size(team_id)
    @max_team_size = @selected_group_team.size
    @current_team_users = User.joins(:teams).where("teams.id = ?", team_id)

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

    #setting the search input to the correct value
    search_input = ""
    if params['search_form'] != nil
      search_input = params['search_form']['search_input']
    elsif params['search_input'] != nil
      search_input = params['search_input']
    end


    #getting users that are in the module and match the search input
    @users_in_module = User.joins(:list_modules).where("list_modules.id = ? AND
                                                        (username LIKE ? OR
                                                        givenname LIKE ? OR
                                                        sn LIKE ? OR
                                                        email LIKE ?)",
                                                        module_id,
                                                        "%" + search_input + "%",
                                                        "%" + search_input + "%",
                                                        "%" + search_input + "%",
                                                        "%" + search_input + "%"
                                                        )
         
    #getting users that are not in any team in this module
    @users_in_module_but_not_in_team = Team.get_students_not_in_team_but_in_module(module_id)

    #removing a student from a group
    if params['remove_student_button'] == "remove_student"
      
      user_to_remove = UserTeam.where("user_id = ? AND team_id =?",
                                       params['student_remove_id'],
                                       team_id)

      if user_to_remove != nil
        user_to_remove.first.destroy
      end

      redirect_to admin_modules_groups_preview_path(module_id: module_id, team_id: team_id)
    end

    #adding a student to a group
    if params['add_student_button'] == "add_student"
      
      user_to_add = UserTeam.create(user_id: params['student_add_id'],
                                    team_id: team_id,
                                    )
      
      redirect_to admin_modules_groups_preview_path(module_id: module_id, team_id: team_id)
    end

    if params['search_button'] == "Search"
      redirect_to admin_modules_groups_preview_path(module_id: module_id, team_id: team_id, search_input: search_input)
    end
    

                                                      
  end

  def admin_modules_groups_add
    authorize! :manage, :admin_modules_groups_add

    #setting the module and team ids to the correct values
    module_id = params['module_id']
    team_id = params['team_id']
    if module_id.nil?
      module_id = params['search_form']['form_module_id']
    end
    if team_id.nil?
      team_id = params['search_form']['form_team_id']
    end

    #get info about the selected team
    @selected_group_team = Team.where(id: team_id).first
    @current_team_size = Team.get_current_team_size(team_id)
    @max_team_size = @selected_group_team.size
    @current_team_users = User.joins(:teams).where("teams.id = ?", team_id)

    #setting the search input to the correct value
    search_input = ""
    if params['search_form'] != nil
      search_input = params['search_form']['search_input']
    elsif params['search_input'] != nil
      search_input = params['search_input']
    end


    #getting users that are in the module and match the search input
    @users_in_module = User.joins(:list_modules).where("list_modules.id = ? AND
                                                        (username LIKE ? OR
                                                        givenname LIKE ? OR
                                                        sn LIKE ? OR
                                                        email LIKE ?)",
                                                        module_id,
                                                        "%" + search_input + "%",
                                                        "%" + search_input + "%",
                                                        "%" + search_input + "%",
                                                        "%" + search_input + "%"
                                                        )
         
    #getting users that are not in any team in this module
    @users_in_module_but_not_in_team = Team.get_students_not_in_team_but_in_module(module_id)
      
    #adding a student to a group
    if params['add_student_button'] == "add_student"
      
      user_to_add = UserTeam.create(user_id: params['student_add_id'],
                                    team_id: team_id,
                                    )
      
      redirect_to admin_modules_groups_add_path(module_id: module_id, team_id: team_id)
    end

    if params['search_button'] == "Search"
      redirect_to admin_modules_groups_add_path(module_id: module_id, team_id: team_id, search_input: search_input)
    end


  end

  def admin_modules_groups_create
    authorize! :manage, :admin_modules_groups_create

    #getting the module information about the currently displayed module
    @module_info = ListModule.where("id = ?", params[:module_id]).first
    @num_of_students = ListModule.num_students_in_mod(params['module_id'])

    #check if submit button was pressed
    if params['rand_btn'] != nil
      if params['rand_btn'] == "enabled" && (params['random_group_size'].length>0 || params['random_num_of_groups'].length>0)
        random_group_size = params['random_group_size']
        random_num_of_groups = params['random_num_of_groups']
        module_id = params['module_id']
        num_of_dates = params['total_chq_period']

        #delete all teams that where previously in the module
        Team.where(list_module_id: module_id).destroy_all
        UserTeam.joins(:team).where("teams.list_module_id = ?", module_id).destroy_all

        #get all students from this module and shuffle them
        students_in_mod = ListModule.students_in_module(module_id).shuffle


        #create teams and randomly put students in them
        if params['random_free_join'].nil?
          #set the team type to random
          ListModule.set_team_type(module_id, "random")

          #case1 given both students per group and num of groups
          if random_group_size.length>0 && random_num_of_groups.length>0
            new_teams = []
            for i in 0...random_num_of_groups.to_i
              new_team_name = "Team " + (i+1).to_s
              new_teams.append(Team.create(name: new_team_name,
                                          size: random_group_size,
                                          list_module_id: module_id))
            end

            #putting students in groups
            while students_in_mod.length > 0 do
              for i in 0...new_teams.length
                if students_in_mod.length>0
                  UserTeam.create(team: new_teams[i], user: students_in_mod[0], signed_agreement: false)
                  students_in_mod.shift(1)
                else
                  break
                end
              end
            end

          end

          #case2 given only students per group 
          if random_group_size.length>0 && random_num_of_groups.length==0
            name_iterator = 1
            while students_in_mod.length > 0 do
              new_team_name = "Team " + name_iterator.to_s
              new_team = Team.create(name: new_team_name,
                                    size: random_group_size,
                                    list_module_id: module_id)

              #link students to the newly created team
              #create as many teams as needed with the given group size
              if students_in_mod.length > random_group_size.to_i
                new_team.users = students_in_mod.take(random_group_size.to_i)
                students_in_mod.shift(random_group_size.to_i)
              else
                new_team.users = students_in_mod
                students_in_mod.shift(students_in_mod.length)
              end
            
              name_iterator += 1
            end

            
          end

          #case3 given only num of groups
          if random_group_size.length==0 && random_num_of_groups.length>0
            new_group_size = (@num_of_students.to_f/random_num_of_groups.to_f).ceil

            new_teams = []
            for i in 0...random_num_of_groups.to_i
              new_team_name = "Team " + (i+1).to_s
              new_teams.append(Team.create(name: new_team_name,
                                          size: new_group_size,
                                          list_module_id: module_id))
            end

            #putting students in groups
            while students_in_mod.length > 0 do
              for i in 0...new_teams.length
                if students_in_mod.length>0
                  UserTeam.create(team: new_teams[i], user: students_in_mod[0], signed_agreement: false)
                  students_in_mod.shift(1)
                else
                  break
                end
              end
            end
          end
        else
          #create teams without putting students in them
          #set the team type to free join
          ListModule.set_team_type(module_id, "free_join")
          #case1 given both students per group and num of groups
          if random_group_size.length>0 && random_num_of_groups.length>0
            new_teams = []
            for i in 0...random_num_of_groups.to_i
              new_team_name = "Team " + (i+1).to_s
              new_teams.append(Team.create(name: new_team_name,
                                          size: random_group_size,
                                          list_module_id: module_id))
            end
          end

          #case2 given only students per group 
          if random_group_size.length>0 && random_num_of_groups.length==0
            name_iterator = 1
            while students_in_mod.length > 0 do
              new_team_name = "Team " + name_iterator.to_s
              new_team = Team.create(name: new_team_name,
                                    size: random_group_size,
                                    list_module_id: module_id)

              #link students to the newly created team
              #create as many teams as needed with the given group size
              if students_in_mod.length > random_group_size.to_i
                students_in_mod.shift(random_group_size.to_i)
              else
                students_in_mod.shift(students_in_mod.length)
              end
            
              name_iterator += 1
            end

            
          end
          #case3 given only num of groups
          if random_group_size.length==0 && random_num_of_groups.length>0
            new_group_size = (@num_of_students.to_f/random_num_of_groups.to_f).ceil

            new_teams = []
            for i in 0...random_num_of_groups.to_i
              new_team_name = "Team " + (i+1).to_s
              new_teams.append(Team.create(name: new_team_name,
                                          size: new_group_size,
                                          list_module_id: module_id))
            end
          end

        end
      end

      #delete all the feedback dates in the system for this module
      FeedbackDate.where(list_module_id: module_id).destroy_all

      #setting up new start and end dates for giving peer feedback
      dates_integrity = true
      previous_end_date = nil
      for i in 1..num_of_dates.to_i
        curr_start_date = DateTime.parse(params['start_time_' + i.to_s]).to_datetime
        curr_end_date = DateTime.parse(params['end_time_' + i.to_s]).to_datetime

        #check if the current window of time starts after the previous one
        if previous_end_date != nil
          if previous_end_date - curr_start_date > 0
            dates_integrity = false
            break
          end
        end
        
        #check if the end date is after the start date
        if curr_start_date - curr_end_date > 0
          dates_integrity = false
          break
        end

        previous_end_date = curr_end_date
      end

      if dates_integrity
        for i in 1..num_of_dates.to_i
          curr_start_date = params['start_time_' + i.to_s]
          curr_end_date = params['end_time_' + i.to_s]
          FeedbackDate.create(list_module_id: module_id,
                              start_date: curr_start_date,
                              end_date: curr_end_date)
        end
      else
        #popup
      end

      

      redirect_back(fallback_location: root_path)
    end
  end

end
