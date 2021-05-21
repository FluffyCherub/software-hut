#-------------------------------------------------------------
# Controller dedicated to all admin related views            
# with privileges cascading down                             
# (also contains pages which the module leaders and          
# teaching asssitants with the right permissions can access) 
# one function correlates to one view file                   
#-------------------------------------------------------------
# Authors: Dominik Laszczyk/Ling Lai                         
# Date: 04/04/2021                                           
#-------------------------------------------------------------

class AdminController < ApplicationController
  require 'csv'
  require 'date'
  require 'active_support/core_ext'
  
  #called to change the current ability(used for cancancan)
  def current_ability(module_privilege = "student")
    @current_ability ||= Ability.new(current_user, module_privilege)
  end

  #the default page which an admin user gets redirected to
  def admin_page
    authorize! :manage, :admin_page

    #redirect to different admin subpages based on the button pressed
    if params['manage_privileges'] != nil
      redirect_to "/admin/privileges"
    elsif params['manage_modules'] != nil 
      redirect_to "/admin/modules"
    end
  end

  #correlates with the view for changing system privileges
  def admin_privileges
    current_ability = User.highest_privilege(current_user.id)
    if current_ability == "teaching_assistant"
      current_ability("teaching_assistant_16")
    else
      current_ability(current_ability)
    end
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
  
  #correlates with the view for viewwing all modules inside the system
  def admin_modules
    if User.is_mod_lead(current_user.username)
      current_ability("module_leader")
    elsif User.is_ta(current_user.username)
      current_ability("teaching_assistant_16")
    end
    authorize! :manage, :admin_modules

    #get the highest privilege of the current user
    @highest_privilege = User.highest_privilege(current_user.id)

    #find the accroding entries in modules table based on search input
    search_input = ""
    if params['search_button'] == "Search"
      search_input = params['search_form']['search_input']
    end

    if @highest_privilege == "teaching_assistant"

      search_input_modules = ListModule.joins(:users)
                                        .where("(years LIKE ? OR name LIKE ? OR code LIKE ? OR description LIKE ? OR semester LIKE ?) AND
                                                  users.id = ?", 
                                                  "%" + search_input + "%",
                                                  "%" + search_input + "%",
                                                  "%" + search_input + "%",
                                                  "%" + search_input + "%",
                                                  "%" + search_input + "%",
                                                  current_user.id)

    else
      search_input_modules = ListModule.where("years LIKE ? OR name LIKE ? OR code LIKE ? OR description LIKE ? OR semester LIKE ?", 
                                                "%" + search_input + "%",
                                                "%" + search_input + "%",
                                                "%" + search_input + "%",
                                                "%" + search_input + "%",
                                                "%" + search_input + "%")
    end

    #getting all the distinct academic years from list of modules
    years = []
    years_temp = []
    if params['search_button'] == "Search"
      years_temp = search_input_modules.select(:years).distinct
    else
      if @highest_privilege == "teaching_assistant"
        years_temp = search_input_modules.select(:years).distinct
      else
        years_temp = ListModule.select(:years).distinct
      end
    end

    #creating an array of distinct academic years
    for i in 0...years_temp.length
      years.append(years_temp[i].years)
    end
    
    #sorting the years in descending order(from the most recent one to the oldest)
    years = years.sort_by { |t| t[5, 8] }.reverse

    #creating a 2d array of modules based on academic years(and search input)
    @modules_by_year = []
    for i in 0...years.length
      current_year_modules = []
     
      if params['search_button'] == "Search"
        current_year_modules = search_input_modules.where(years: years[i]).order(:code)
      else
        if @highest_privilege == "teaching_assistant"
          current_year_modules = search_input_modules.where(years: years[i]).order(:code)
        else
          current_year_modules = ListModule.where(years: years[i]).order(:code)
        end
      end
     
      @modules_by_year.append(current_year_modules)
    end

    #get the number of modules which are displayed on the website
    @num_of_modules = 0
    if params['search_button'] == "Search"
      @num_of_modules = @modules_by_year.flatten.length
    else
      if @highest_privilege != "teaching_assistant"
        @num_of_modules = search_input_modules.length
      else
        @num_of_modules = ListModule.all.length
      end
    end
    
  end

  #correlates with the view for looking at a certain module page
  def admin_modules_preview
    module_id = 0
    if params[:module_id].nil?
      module_id = params['search_form']['form_module_id']
    else
      module_id = params[:module_id]
    end

    current_ability(User.get_module_privilege(module_id, current_user.id))
    authorize! :manage, :admin_modules_preview

    #getting the module information about the currently displayed module
    @module_info = ListModule.where("id = ?", module_id).first

    #get the last feedback period which is closed
    @last_finished_period = FeedbackDate.get_last_finished_period(Time.now, module_id)


    #getting the module leader of the currently displayed module
    @module_leaders = User.joins(:list_modules).where("user_list_modules.privilege = ? AND
                                                      list_modules.id = ?",
                                                      "module_leader",
                                                      module_id).order(:givenname, :sn)

    #getting the teaching assistants of the currently displayed module
    @teaching_assistants = User.joins(:list_modules).where("user_list_modules.privilege LIKE ? AND
                                                            list_modules.id = ?",
                                                            "%teaching_assistant%",
                                                            module_id).order(:givenname, :sn)

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
                                          user_list_modules.privilege LIKE ?) AND
                                          user_list_modules.privilege != ?", 
                                          module_id,
                                            "%" + search_input + "%",
                                            "%" + search_input + "%",
                                            "%" + search_input + "%",
                                            "%" + search_input + "%",
                                            "%" + search_input + "%",
                                            "suspended") 
                                .order(:givenname, :sn)

    if params['search_button'] == "Search"
      redirect_to admin_modules_preview_path(module_id: module_id, search_input: params['search_form']['search_input'])
    end
  
  end

  #imports users to to the module from a .csv file
  def import_users_csv
    
    #taking a csv file and adding students to modules based on it
    csv_integrity = ListModule.import(params['csv_file'], params['module_id'])

    #if data in csv fine, rendering a partial with updated users in module
    if csv_integrity

      @div_name = "#module_users_table"

      #getting users for the correct module 
      @current_module_users = User.joins(:list_modules)
                                  .where("list_modules.id = ? AND
                                          user_list_modules.privilege != ?", 
                                          params[:module_id],
                                          "suspended") 
                                  .order(:givenname, :sn)

      respond_to do |format|
        format.js { render layout: false }
      end
    end

  end

  #correlates with the view for module creation
  def admin_modules_create
    current_ability = User.highest_privilege(current_user.id)
    if current_ability == "teaching_assistant"
      current_ability("teaching_assistant_15")
    else
      current_ability(current_ability)
    end
    authorize! :manage, :admin_modules_create

    #generating academic years based on current year
    @generated_years = ListModule.generate_years(Time.now.year-1, 6)
    
    if params['create_module_button'] == "Create"
      #getting all the variables needed to create a module
      module_name = params['module_create_form']['module_name']
      module_code = params['module_create_form']['module_code']
      module_description = params['module_create_form']['module_description']
      semester = params['module_create_form']['semester']
      years = params['module_create_form']['years']
      level = params['module_create_form']['level']

      max_module_name_length = 150
      max_module_code_length = 20
      max_module_description_length = 1000

      #check if there is no empty field supplied by the user
      if (module_name != nil && module_code != nil && module_description != nil && semester != nil && years != nil && level != nil &&
         module_name.length != 0 && module_code.length != 0 && module_description.length != 0 && semester.length != 0 && years.length != 0 && level.length != 0)
        
        #checking if a module with this name and year is in the system
        module_check = ListModule.where("name = ? AND years = ? AND code = ? AND semester = ?", 
                                         module_name,
                                         years,
                                         module_code,
                                         semester
                                         )

        #check if module with this data doesnt already exist in the system
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


          if module_name.length >= max_module_name_length
            respond_to do |format|
              format.js { render :js => "myAlertTopEditableError(\"The Module Name has to have less than " + max_module_name_length.to_s + " characters!\");" }
            end
          elsif module_code.length >= max_module_code_length
            respond_to do |format|
              format.js { render :js => "myAlertTopEditableError(\"The Module Code has to have less than " + max_module_code_length.to_s + " characters!\");" }
            end
          elsif module_description.length >= max_module_description_length
            respond_to do |format|
              format.js { render :js => "myAlertTopEditableError(\"The Module Description has to have less than " + max_module_description_length.to_s + " characters!\");" }
            end
          else
            #popup that module was created successfully

            #wizard path for adding users to the created module
            wizard_path = "\"" + "/admin/modules/preview?module_id=" + created_module.id.to_s + "\""

            #functions to alert and show wizard toast
            call_alert_success = "myAlertTopEditableSuccess(\"Module created successfully!\");"
            call_wizard_toast = "add_wizard_toast(\"You just created a new module!\",
                                                  \"The next step we suggest is to add users to the module using a <strong>.CSV</strong> file or by <strong>adding individual users</strong>.\", " +
                                                  wizard_path + ");"
            respond_to do |format|
              format.js { render :js => call_alert_success + call_wizard_toast }
            end
          end


        else
          #popup that this module already exists
          respond_to do |format|
            format.js { render :js => "myAlertTopEditableError(\"This Module already exists!\");" }
          end
        end
      else
        
        #error popups
        if module_name.nil? || module_name.length == 0
          #popup that module name was empty
          respond_to do |format|
            format.js { render :js => "myAlertTopEditableError(\"Please enter a Module Name!\");" }
          end
        elsif module_code.nil? || module_code.length == 0
          #popup that module code was empty
          respond_to do |format|
            format.js { render :js => "myAlertTopEditableError(\"Please enter a Module Code!\");" }
          end
        elsif module_description != nil || module_description.length == 0
          #popup that module description was empty
          respond_to do |format|
            format.js { render :js => "myAlertTopEditableError(\"Please enter a Description!\");" }
          end
        end

      end
    end
    
  end

  #correlates with the view for editing/cloning modules
  def admin_modules_edit
    current_ability(User.get_module_privilege(params[:module_id], current_user.id))
    authorize! :manage, :admin_modules_edit

    max_module_name_length = 150
    max_module_code_length = 20
    max_module_description_length = 1000

    #check if edit button was clicked
    if params['edit_module_button'] == "Edit"
      module_name = params['module_edit_form']['module_name']
      module_code = params['module_edit_form']['module_code']
      years = params['module_edit_form']['years']
      module_description = params['module_edit_form']['module_description']
      semester = params['module_edit_form']['semester']
      form_module_id = params['module_edit_form']['form_module_id']
      level = params['module_edit_form']['level']

      #check if there is no empty field supplied by the user
      if (module_name != nil && module_code != nil && module_description != nil && semester != nil && years != nil && level != nil &&
          module_name.length != 0 && module_code.length != 0 && module_description.length != 0 && semester.length != 0 && years.length != 0 && level.length != 0)
        
        #validate all the fields
        if module_name.length >= max_module_name_length
          respond_to do |format|
            format.js { render :js => "myAlertTopEditableError(\"The Module Name has to have less than " + max_module_name_length.to_s + " characters!\");" }
          end
        elsif module_code.length >= max_module_code_length
          respond_to do |format|
            format.js { render :js => "myAlertTopEditableError(\"The Module Code has to have less than " + max_module_code_length.to_s + " characters!\");" }
          end
        elsif module_description.length >= max_module_description_length
          respond_to do |format|
            format.js { render :js => "myAlertTopEditableError(\"The Module Description has to have less than " + max_module_description_length.to_s + " characters!\");" }
          end
        else
          #checking if a module with this name and year is in the system
          module_check = ListModule.where("name = ? AND years = ? AND code = ? AND semester = ? AND id != ?", 
                                          module_name,
                                          years,
                                          module_code,
                                          semester,
                                          form_module_id
                                          )

          #check if module with this data doesnt already exist in the system
          if module_check.length == 0
            current_module = ListModule.find_by(id: form_module_id)
            current_module.update(name: module_name,
                                  code: module_code,
                                  description: module_description,
                                  semester: semester,
                                  years: years,
                                  level: level)
            
            #popup that module was updated successfully
            respond_to do |format|
              format.js { render :js => "myAlertTopEditableSuccess(\"Module edited successfully!\")" }
            end
          else
            #popup that this module already exists
            respond_to do |format|
              format.js { render :js => "myAlertTopEditableError(\"This Module already exists.\")" }
            end
          end

        end

      else
        #popups for missing fields
        if module_name.nil? || module_name.length == 0
          respond_to do |format|
            format.js { render :js => "myAlertTopEditableError(\"Please enter the Module Name.\")" }
          end
        elsif module_code.nil? || module_code.length == 0
          respond_to do |format|
            format.js { render :js => "myAlertTopEditableError(\"Please enter the Module Code\")" }
          end
        elsif module_description.nil? || module_description.length == 0
          respond_to do |format|
            format.js { render :js => "myAlertTopEditableError(\"Please enter a Description.\")" }
          end
        end
      end

      #check if the clone button was clicked
    elsif params['clone_module_button'] == "Clone"
      module_name = params['module_edit_form']['module_name']
      module_code = params['module_edit_form']['module_code']
      years = params['module_edit_form']['years']
      module_description = params['module_edit_form']['module_description']
      semester = params['module_edit_form']['semester']
      form_module_id = params['module_edit_form']['form_module_id']
      level = params['module_edit_form']['level']

      #check if there is no empty field supplied by the user
      if (module_name != nil && module_code != nil && module_description != nil && semester != nil && years != nil && level != nil &&
          module_name.length != 0 && module_code.length != 0 && module_description.length != 0 && semester.length != 0 && years.length != 0 && level.length != 0)
        
        #validate all the fields
        if module_name.length >= max_module_name_length
          respond_to do |format|
            format.js { render :js => "myAlertTopEditableError(\"The Module Name has to have less than " + max_module_name_length.to_s + " characters!\");" }
          end
        elsif module_code.length >= max_module_code_length
          respond_to do |format|
            format.js { render :js => "myAlertTopEditableError(\"The Module Code has to have less than " + max_module_code_length.to_s + " characters!\");" }
          end
        elsif module_description.length >= max_module_description_length
          respond_to do |format|
            format.js { render :js => "myAlertTopEditableError(\"The Module Description has to have less than " + max_module_description_length.to_s + " characters!\");" }
          end
        else

          #checking if a module with this name and year is in the system
          module_check = ListModule.where("name = ? AND years = ? AND code = ? AND semester = ?", 
                                          module_name,
                                          years,
                                          module_code,
                                          semester
                                          )

          #check if module with this data doesnt already exist in the system
          if module_check.length == 0
            cloned_module = ListModule.find_or_create_by(name: module_name,
                                                        code: module_code,
                                                        description: module_description,
                                                        semester: semester,
                                                        years: years,
                                                        created_by: current_user.username,
                                                        level: level)
          
            #adding module leaders to the cloned module if checkbox checked
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

            #inheriting teaching assistants if checkbox checked
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

            #popup that module was cloned successfully
            respond_to do |format|
              format.js { render :js => "myAlertTopEditableSuccess(\"Module cloned successfully!\")" }
            end
          else
            #popup that this module already exists
            respond_to do |format|
              format.js { render :js => "myAlertTopEditableError(\"This Module already exists.\")" }
            end
          end

        end
      else
        #popups if empty fields
        if module_name.nil? || module_name.length == 0
          respond_to do |format|
            format.js { render :js => "myAlertTopEditableError(\"Please enter the Module Name.\")" }
          end
        elsif module_code.nil? || module_code.length == 0
          respond_to do |format|
            format.js { render :js => "myAlertTopEditableError(\"Please enter the Module Code\")" }
          end
        elsif module_description.nil? || module_description.length == 0
          respond_to do |format|
            format.js { render :js => "myAlertTopEditableError(\"Please enter a Description.\")" }
          end
        end
      end

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

  #correlates with the view for viewing teams/dealing with problems
  def admin_modules_groups

    #getting the module id based on was form was submitted on the page
    if params['problem_form'] != nil
      @module_id = params['problem_form']['form_module_id']
    elsif params['search_form'] != nil
      @module_id = params['search_form']['form_module_id']
    elsif params['module_id'] != nil
      @module_id = params['module_id']
    end

    #checking if current user has privilege to access this page
    current_ability(User.get_module_privilege(@module_id, current_user.id))
    authorize! :manage, :admin_modules_groups

    #checking if all teams in this modules are approved
    @all_teams_approved = ListModule.all_approved(@module_id)

    #getting the number of students in a module
    @num_students_in_module = ListModule.num_students_in_mod(@module_id)

    #checking if this module has currently active teams
    @has_active_teams = ListModule.has_active_teams(@module_id)

    #getting a list of ta's and modules leaders for assigning problems
    ta_and_mod_lead_object = ListModule.get_ta_and_mod_lead(@module_id)

    @ta_and_mod_lead = ta_and_mod_lead_object.pluck("users.givenname || ' ' || users.sn || ' - ' || users.username")

    @ta_and_mod_lead_usernames = ta_and_mod_lead_object.pluck(:username)

    #assigning and solving problems
    if params['problem_form'] != nil
      problem_id = params['problem_form']['form_problem_id']
      if params['assign_button'] == "Assign"
        user_to_assign = params['problem_form']['assign_list'].split(" ")[-1]
        
        #assigning problem to the chosen user
        Problem.assign(user_to_assign, problem_id)
        Problem.change_status(problem_id, "assigned")
      end

      #solving the problem by the current user
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
                                                    ((users.givenname LIKE ? OR
                                                    users.sn LIKE ? OR
                                                    users.email LIKE ? OR
                                                    teams.name LIKE ? OR 
                                                    teams.topic LIKE ? OR
                                                    users.username LIKE ?) AND
                                                    (teams.status = ? OR teams.status = ?))",
                                                    @module_id,
                                                    "%" + search_input + "%",
                                                    "%" + search_input + "%",
                                                    "%" + search_input + "%",
                                                    "%" + search_input + "%",
                                                    "%" + search_input + "%",
                                                    "%" + search_input + "%",
                                                    "waiting_for_approval",
                                                    "active"
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

  end

  def approve_teams
    module_id = params['module_id']

    #checking if current user has privilege to access this page
    current_ability(User.get_module_privilege(module_id, current_user.id))
    authorize! :manage, :admin_modules_groups

    ListModule.approve_teams(module_id)

    wizard = "add_wizard_toast(\"You just approved Teams\", 
              \"You are now done with the proccess of setting up this module, to see more information about this module click here:\", 
              \"/admin/modules/preview?module_id=" + module_id + "\")"

    respond_to do |format|
      format.js { render :js => "myAlertTopEditableSuccess(\"Teams approved successfully!\");disable_approve_button();" + wizard }
    end
  end

  #correlates with the view for changing module privileges
  def admin_modules_privilege
    #checking if the current user has access to this page
    current_ability(User.get_module_privilege(params[:module_id], current_user.id))
    authorize! :manage, :admin_modules_privilege

    #loading the peivilege of the selected user
    @saved_privilege = UserListModule.where(list_module_id: params['module_id'],
                                            user_id: params['user_id']).first.privilege

    #saving the chosen privilege if save button clicked
    if params['save_button'] == "Save"
      privilege_to_update = UserListModule.where(list_module_id: params['module_id'],
                                                   user_id: params['user_id'])

      #student option
      if params['options1'] == "on"
        privilege_to_update.update(privilege: "student")
        
        #teaching asssitant option
      elsif params['options2'] == "on"

        #get values of switches for teaching asssitant privileges
        priv_1 = params['privilege_1']
        priv_2 = params['privilege_2']
        priv_3 = params['privilege_3']
        priv_4 = params['privilege_4']
        ta_type = ""
        
        #assign the selected user the correct teaching assistant permission based on flipped switches
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

        #module leader option
      elsif params['options3'] == "on"
        #module_leader
        privilege_to_update.update(privilege: "module_leader")
        
      end

      @close_window = "true"

    end

    render layout: 'empty'
  end

  #correlates with the view for the team page(adding removing students)
  def admin_modules_groups_preview
    current_ability(User.get_module_privilege(params[:module_id], current_user.id))
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
    ta_and_mod_lead_object = ListModule.get_ta_and_mod_lead(module_id)

    @ta_and_mod_lead = ta_and_mod_lead_object.pluck("users.givenname || ' ' || users.sn || ' - ' || users.username")

    @ta_and_mod_lead_usernames = ta_and_mod_lead_object.pluck(:username)

    #assigning and solving problems
    if params['problem_form'] != nil
      problem_id = params['problem_form']['form_problem_id']
      if params['assign_button'] == "Assign"
        user_to_assign = params['problem_form']['assign_list'].split(" ")[-1]
        
        #assigning a problem to the selected user
        Problem.assign(user_to_assign, problem_id)
      end

      #marking the selected problem as solved by the current user
      if params['solve_button'] == "Mark as solved"
        if Problem.is_assigned(problem_id) == false
          Problem.assign(current_user.username, problem_id)
        end

        Problem.solve(current_user.username, problem_id, Time.now)
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

  #correlates with the view for adding students to teams
  def admin_modules_groups_add
    #checking if the current user has access to this page
    current_ability(User.get_module_privilege(params[:module_id], current_user.id))
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

         
    #getting users that are not in any team in this module
    @users_in_module_but_not_in_team = Team.get_students_not_in_team_but_in_module(module_id)

    @users_in_module_but_not_in_team = @users_in_module_but_not_in_team.where("username LIKE ? OR
                                                                              givenname LIKE ? OR
                                                                              sn LIKE ? OR
                                                                              email LIKE ?",
                                                                              "%" + search_input + "%",
                                                                              "%" + search_input + "%",
                                                                              "%" + search_input + "%",
                                                                              "%" + search_input + "%"
                                                                              )
      
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

  #correlates with the view for creating teams
  def admin_modules_groups_create
    module_id = params['module_id']

    #checking if the current user has access to this page
    current_ability(User.get_module_privilege(module_id, current_user.id))
    authorize! :manage, :admin_modules_groups_create

    #getting the module information about the currently displayed module
    @module_info = ListModule.where("id = ?", module_id).first
    @num_of_students = ListModule.num_students_in_mod(module_id)

    #checking if all teams in this modules are approved
    @all_teams_approved = ListModule.all_approved(@module_id)

    #check if submit button was pressed
    if params['rand_btn'] != nil

      #delete all the feedback dates connected to unapproved teams for this module
      FeedbackDate.joins(:teams)
                  .where("feedback_dates.list_module_id = ? AND teams.status = ?", 
                          module_id, 
                          "waiting_for_approval").group("feedback_dates.id").destroy_all
      
      #delete all unapproved teams in the module
      Team.where(list_module_id: module_id, status: "waiting_for_approval").destroy_all

      #storing newly created teams
      created_teams = []

      if params['rand_btn'] == "enabled" && (params['random_group_size'].length>0 || params['random_num_of_groups'].length>0)
        random_group_size = params['random_group_size']
        random_num_of_groups = params['random_num_of_groups']
        module_id = params['module_id']
        num_of_dates = params['total_chq_period']

        #getting students that are not in any team in this module
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
              new_team = (Team.create(name: new_team_name,
                                      size: random_group_size,
                                      list_module_id: module_id))

              new_teams.append(new_team)
              created_teams.append(new_team)
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

              created_teams.append(new_team)

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
              new_team = (Team.create(name: new_team_name,
                                      size: new_group_size,
                                      list_module_id: module_id))

              new_teams.append(new_team)
              created_teams.append(new_team)
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
              new_team = (Team.create(name: new_team_name,
                                          size: random_group_size,
                                          list_module_id: module_id))

              new_teams.append(new_team)
              created_teams.append(new_team)
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

              created_teams.append(new_team)

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
              new_team = (Team.create(name: new_team_name,
                                      size: new_group_size,
                                      list_module_id: module_id))

              new_teams.append(new_team)
              created_teams.append(new_team)
            end
          end

        end
      end

      if params['topic_btn'] == "enabled"
        num_of_topics = params['total_chq'].to_i
        topics_integrity = true
        total_team_size = 0
        num_of_dates = params['total_chq_period']

        #check if all the fields for topic name/team size/num of teams were filled
        for i in 1..num_of_topics
          current_topic_name = params["topic_" + i.to_s]
          current_topic_size = params["size_" + i.to_s]
          current_topic_amount = params["amount_" + i.to_s]
          if current_topic_name.nil? || current_topic_size.nil? || current_topic_amount.nil?
            topics_integrity = false
            break
          end
        end

        #if all fields were filled, creating teams with given topics and putting people inside
        if topics_integrity
          new_teams = []
          team_name_number = 1

          for i in 1..num_of_topics  
            current_topic_name = params["topic_" + i.to_s]
            current_topic_size = params["size_" + i.to_s].to_i
            current_topic_amount = params["amount_" + i.to_s].to_i

            for j in 0...current_topic_amount
              new_team_name = "Team " + team_name_number.to_s
              new_team = (Team.create(name: new_team_name,
                                      size: current_topic_size,
                                      topic: current_topic_name,
                                      list_module_id: module_id))

              new_teams.append(new_team)
              created_teams.append(new_team)

              team_name_number += 1
              total_team_size += current_topic_size
            end
          end
          

          if params['topic_free_join'] == "checked"
            #set the team type to free join
            ListModule.set_team_type(module_id, "free_join")
          else
            #set the team type to random
            ListModule.set_team_type(module_id, "random")

            #here put students in newly created teams at random

            #getting students that are not in any team in this module
            students_in_mod = ListModule.students_in_module(module_id).shuffle

            num_students_in_teams = 0

        
            #putting students in new teams until they are filled up
            while (total_team_size > num_students_in_teams) && (students_in_mod.length) > 0 do
              for i in 0...new_teams.length
                if (total_team_size > num_students_in_teams) && (students_in_mod.length > 0)
                  if new_teams[i].size > Team.get_current_team_size(new_teams[i].id)
                    UserTeam.create(team: new_teams[i], user: students_in_mod[0], signed_agreement: false)
                    students_in_mod.shift(1)
                    num_students_in_teams += 1
                  end
                else
                  break
                end
              end
            end

            #putting the left over students in teams(team1=>team2...)
            while students_in_mod.length > 0
              for i in 0...new_teams.length
                if students_in_mod.length > 0
                  UserTeam.create(team: new_teams[i], user: students_in_mod[0], signed_agreement: false)
                  students_in_mod.shift(1)
                end
              end
            end

          end
        end
      end

      #--------------------------------FEEDBACK DATES SECTION--------------------------------#


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
          new_f_period = FeedbackDate.create(list_module_id: module_id,
                                             start_date: curr_start_date,
                                             end_date: curr_end_date)

          for j in 0...(created_teams.length)
            TeamFeedbackDate.create(team_id: created_teams[j].id,
                                    feedback_date_id: new_f_period.id)
          end
        end
      else
        #popup
      end
      
      wizard = "add_wizard_toast(\"You just created teams for this module!\", 
              \"The next step we suggest is to review and approve teams, you can do that on this page at the bottom:\",
              \"/admin/modules/groups?module_id=" + @module_info.id.to_s + "\");"
      
      respond_to do |format|
        format.js { render :js => "myAlertTopEditableSuccess(\"Teams created successfully!\");" + wizard }
      end
    end
  end

  def admin_modules_periods_edit
    @module_id = params['module_id']

    #checking if the current user has access to this page
    current_ability(User.get_module_privilege(@module_id, current_user.id))
    authorize! :manage, :admin_modules_periods_edit


    #getting all future feedback periods for this module
    @not_started_f_periods = ListModule.get_future_feedback_periods(@module_id, Time.now)

  end

  def edit_feedback_periods
    feedback_date_id = params['feedback_period_id']
    @module_id = params['module_id']

    f_period_integrity = true

    #check if the selected feedback period hasnt started
    f_period_start_date = FeedbackDate.find(feedback_date_id.to_i).start_date
    if Time.now - f_period_start_date > 0 

      #the period has already started
      f_period_integrity = false

      respond_to do |format|
        format.js { render :js => "myAlertTopEditableError(\"This period has already started\");" }
      end
    end


    if f_period_integrity == true

      #remove the selected period
      FeedbackDate.find(feedback_date_id.to_i).destroy

      #getting all future feedback periods for this module
      @not_started_f_periods = ListModule.get_future_feedback_periods(@module_id, Time.now)

      respond_to do |format|
        format.js {render layout: false}
      end
    end

  end

  def send_feedback_mailmerge
    module_id = params['module_id']

    #checking if the current user has access to this page
    current_ability(User.get_module_privilege(@module_id, current_user.id))
    authorize! :manage, :send_feedback_mailmerge

    #latest finished feedback period for this module
    last_finished_period = FeedbackDate.get_last_finished_period(Time.now, module_id)
    last_feedback_status = last_finished_period.feedback_status

    #check if latest feedback is approved
    if last_feedback_status == "not_approved"
      render "errors/error_500"
    elsif last_feedback_status == "approved"
      period_number = FeedbackDate.get_period_number(last_finished_period.id)
      module_info = ListModule.find(module_id.to_i)

      #teams in this module, that are connected to the latest finished feedback period
      teams_in_module = Team.joins(:feedback_dates)
                            .where("teams.list_module_id = ? AND 
                                    feedback_dates.id = ?", 
                                    module_id,
                                    last_finished_period.id)
      
      #loop through teams in module
      for i in 0...teams_in_module.length

        #get all team members
        team_members = User.joins(:teams).where("teams.id = ?", teams_in_module[i].id)

        #loop through all the team members
        for j in 0...team_members.length
          email = team_members[j].email
          receiver_full_name = team_members[j].givenname + " " + team_members[j].sn
          submitter_full_name = current_user.givenname + " " + current_user.sn
          feedback_averages = PeerFeedback.get_average_feedback_data_for_period(team_members[j].username, teams_in_module[i].id, last_finished_period)
          feedback_descriptions = PeerFeedback.array_int_to_feedback_long(feedback_averages)
          appreciate_request = PeerFeedback.get_appreciate_request_for_student(team_members[j].username, teams_in_module[i].id, last_finished_period.id)
          appreciate_array = appreciate_request[0]
          request_array = appreciate_request[1]
       
          #sending an email with the correct peer feedback
          UserMailer.peer_feedback(email, receiver_full_name, submitter_full_name, last_finished_period, feedback_descriptions, module_info, appreciate_array, request_array, period_number).deliver
          
        end
      end

      respond_to do |format|
        format.js { render :js => "myAlertTopEditableSuccess(\"Emails with Peer feedback have been sent successfully!\");" }
      end

      
    end
  end

  def remove_student_from_team
    @student_to_remove_id = params['student_remove_id']
    @team_id = params['team_id']
    @module_id = params['module_id']
    @team_number = params['team_number']

    @div_name = "#team_" + @team_number

    Team.remove_student(@student_to_remove_id, @team_id)

    @team_members = Team.get_current_team_members(@team_id)

    @team_header_div = "#team_header_" + @team_number

    @has_unsolved_problems = Team.has_unsolved_problems(@team_id)
    @has_assigned_problems = Team.has_assigned_problems(@team_id)

    @team_object = Team.find(@team_id.to_i)

    @team_current_size = Team.get_current_team_size(@team_object.id)
    @team_size_limit = @team_object.size

    respond_to do |format|
      format.js {render layout: false}
    end
  end

  def assign_solve_problem
    @problem_id = params['problem_id']
    @team_number = params['team_number']
    @problem_number = params['problem_number']
    @assign_list = params['assign_list']
    @module_id = params['module_id']
    @team_id = params['team_id']
    @assign_button = params['assign_button']
    @solve_button = params['solve_button']

    
    @team_object = Team.find(@team_id.to_i)


    #assign problem if assign button was clicked
    if @assign_button == "assign_button"
      Problem.assign(@assign_list, @problem_id)
      Problem.change_status(@problem_id, "assigned")
    end


    #solve problem if mark as solved was clicked
    if @solve_button == "solve_button"
      if Problem.is_assigned(@problem_id) == false
        Problem.assign(current_user.username, @problem_id)
      end

      Problem.solve(current_user.username, @problem_id, Time.now)
      Problem.change_status(@problem_id, "solved")
    end


    #get who is the problem assigned to
    @assigned_to = User.get_first_last(Problem.assigned_to(@problem_id))

    #get by who was the problem solved and the date
    @solved_by = ""
    @solved_on = ""
    @problem_object = Problem.find(@problem_id.to_i)

    if @problem_object.status == "solved"
      @solved_by = User.get_first_last(@problem_object.solved_by)
      @solved_on = @problem_object.solved_on.strftime("%I:%M %p %d/%m/%Y")
    end

    @problem_assigned_div = "#problem_assigned_" + @team_number + "_" + @problem_number
    @problem_solved_div = "#problem_solved_info_" + @team_number + "_" + @problem_number
    @team_header_div = "#team_header_" + @team_number
    @assign_solve_buttons_div = "#assign_solve_buttons_" + (@team_number.to_i+1).to_s + "_" + (@problem_number.to_i+1).to_s

    @has_unsolved_problems = Team.has_unsolved_problems(@team_id)
    @has_assigned_problems = Team.has_assigned_problems(@team_id)

    @team_current_size = Team.get_current_team_size(@team_object.id)
    @team_size_limit = @team_object.size
    
    respond_to do |format|
      format.js {render layout: false}
    end
  end

  def add_individual_user
    user_integrity = true

    add_username = params['add_username']
    add_email = params['add_email']
    add_first_name = params['add_first_name']
    add_last_name = params['add_last_name']

    #check if all the fields were provided
    if add_username.length>0 && add_email.length>0 && add_first_name.length>0 && add_last_name.length>0 && add_email.include?('@') == false

      add_email = add_email + "@sheffield.ac.uk"

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
        
      else
        user_integrity = false

        #popup this user is already in this module
        respond_to do |format|
          format.js { render :js => "myAlertTopEditableError(\"This user is already in this module.\")" }
        end
      end
    else
      user_integrity = false

      #popup one of the values was not provided
      if add_username.length == 0
        respond_to do |format|
          format.js { render :js => "myAlertTopEditableError(\"Please provide a username.\")" }
        end
      elsif add_email.length == 0
        respond_to do |format|
          format.js { render :js => "myAlertTopEditableError(\"Please provide an email.\")" }
        end
      elsif add_first_name.length == 0
        respond_to do |format|
          format.js { render :js => "myAlertTopEditableError(\"Please provide a first name.\")" }
        end
      elsif add_last_name.length == 0
        respond_to do |format|
          format.js { render :js => "myAlertTopEditableError(\"Please provide a last name.\")" }
        end
      elsif add_email.include?('@') == true
        respond_to do |format|
          format.js { render :js => "myAlertTopEditableError(\"Please provide an email without the domain.\")" }
        end

      end


    end


    if user_integrity

      @div_name = "#module_users_table"

      #getting users for the correct module 
      @current_module_users = User.joins(:list_modules)
                                  .where("list_modules.id = ? AND
                                          user_list_modules.privilege != ?", 
                                          params[:module_id],
                                          "suspended") 
                                  .order(:givenname, :sn)

      respond_to do |format|
        format.js { render :file => "/admin/import_users_csv.js.erb" }
      end
    end


  end

  def admin_modules_groups_docs
    module_id = params['module_id']
    team_id = params['team_id']

    @team = Team.find(team_id.to_i)

    @tmrs = Tmr.where(team_id: team_id.to_i)

  end

end
