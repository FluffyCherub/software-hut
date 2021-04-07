class AdminController < ApplicationController

  def admin_page
    #check if the user trying to access is an admin, otherwise redirect to root
    if current_user.admin == false
      redirect_to "/"
    end

    #redirect to different admin subpages based on the button pressed
    if params['manage_privileges'] == "Manage Privileges"
      redirect_to "/admin/privileges"
    elsif params['manage_modules'] == "Manage Modules"
      redirect_to "/admin/modules"
    end
  end

  def admin_privileges
    #check if the user trying to access is an admin, otherwise redirect to root
    if current_user.admin == false
      redirect_to "/"
    end
    
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
    
    #check if the user trying to access is an admin, otherwise redirect to root
    if current_user.admin == false
      redirect_to "/"
    end

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
    #check if the user trying to access is an admin, otherwise redirect to root
    if current_user.admin == false
      redirect_to "/"
    end

    #getting the module leader of the currently displayed module
    @module_leaders = User.joins(:list_modules).where("user_list_modules.privilege = ? AND
                                                      list_modules.id = ?",
                                                      "module_leader",
                                                      params[:module_id]).order(:givenname, :sn)

    puts "BOIIIIIIIIIIIIIIIIIIII"
    puts @module_leaders

    #getting the teaching assistants of the currently displayed module
    @teaching_assistants = User.joins(:list_modules).where("user_list_modules.privilege LIKE ? AND
                                                            list_modules.id = ?",
                                                            "%teaching_assistant%",
                                                            params[:module_id]).order(:givenname, :sn)

    #getting the module information about the currently displayed module
    @module_info = ListModule.where("id = ?", params[:module_id]).first


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
  
  end

  def admin_modules_create
    #check if the user trying to access is an admin, otherwise redirect to root
    if current_user.admin == false
      redirect_to "/"
    end

    #generating academic years based on current year
    @generated_years = ListModule.generate_years(Time.now.year, 5)
    
    if params['create_module_button'] == "Create"

      #checking if a module with this name and year is in the system
      module_check = ListModule.where("name = ? AND years = ?", 
                                       params['module_create_form']['module_name'],
                                       params['module_create_form']['years'])

      if module_check.length == 0
        #creating a module with the given parameters
        created_module = ListModule.find_or_create_by(name: params['module_create_form']['module_name'],
                                                      code: params['module_create_form']['module_code'],
                                                      description: params['module_create_form']['module_description'],
                                                      semester: params['module_create_form']['semester'],
                                                      years: params['module_create_form']['years'],
                                                      created_by: current_user.username,
                                                      )
      
        #making the current user module leader if he checked the checkbox
        if params['module_create_form']['module_leader'] == "checked-value" && created_module != nil
          add_mod_leader = UserListModule.create(list_module_id: created_module.id,
                                user_id: current_user.id,
                                privilege: "module_leader")
        end
      end
    end
    
  end

  def admin_modules_edit
    #check if the user trying to access is an admin, otherwise redirect to root
    if current_user.admin == false
      redirect_to "/"
    end

    if params['edit_module_button'] == "Edit"

      #checking if a module with this name and year is in the system
      module_check = ListModule.where("name = ? AND years = ? AND id != ?", 
                                       params['module_edit_form']['module_name'],
                                       params['module_edit_form']['years'],
                                       params['module_edit_form']['form_module_id'])

      if module_check.length == 0
        current_module = ListModule.find_by(id: params['module_edit_form']['form_module_id'])
        current_module.update(name: params['module_edit_form']['module_name'],
                              code: params['module_edit_form']['module_code'],
                              description: params['module_edit_form']['module_description'],
                              semester: params['module_edit_form']['semester'],
                              years: params['module_edit_form']['years'],)
        
      end

      redirect_to admin_modules_preview_path(module_id: params['module_edit_form']['form_module_id'])
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
    #check if the user trying to access is an admin, otherwise redirect to root
    if current_user.admin == false
      redirect_to "/"
    end
    
    ##setting the search input parameter to display the correct teams
    if params['search_button'] == "Search"
      search_input = params['search_form']['search_input']
    elsif params['search_input'] != nil
      search_input = params['search_input']
    else
      search_input = ""
    end

    #getting teams for the correct search input
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
                                                    ).distinct.order(:name)
    
    if params['search_button'] == "Search"
      mod_id = params['search_form']['form_module_id']
      redirect_to admin_modules_groups_path(module_id: mod_id, search_input: params['search_form']['search_input'])
    end

  end

  def admin_modules_privilege
    #check if the user trying to access is an admin, otherwise redirect to root
    if current_user.admin == false
      redirect_to "/"
    end

    
    

    @saved_privilege = UserListModule.where(list_module_id: params['module_id'],
                                            user_id: params['user_id']).first.privilege

    
    puts @saved_privilege
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
  end
end
