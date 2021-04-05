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
        current_year_modules = search_input_modules.where(years: years[i])
      else
        current_year_modules = ListModule.where(years: years[i])
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


end
