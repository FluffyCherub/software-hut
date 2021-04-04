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

end
