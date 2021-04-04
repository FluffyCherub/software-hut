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
      @users_list = User.all
    end

    if params['suspend_button'] == "Suspend"
      puts "SUUUUUUUUUUUUUUUUUUUUUUUUSPEND"
      puts params['privilege_form']['form_username']
    elsif params['unsuspend_button'] == "Unsuspend"
      puts "UNNNNNSSSSUUUUUSPEEEEEND"
    elsif params['make_admin_button'] == "Make Admin"
      puts "MAAAAAAAAAAAAKKKKKKEEEEEE AAAAAAAAADDDDDDDDMMIN"
    elsif params['remove_admin_button'] == "Remove Admin"
      puts "REMOOOOOOVVVVVVVEEEEEE AAAAADDDDDDMMIIIINNNNNN"
    end

  end


end
