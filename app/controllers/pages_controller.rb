class PagesController < ApplicationController

  skip_authorization_check

  def home
    @current_nav_identifier = :home
  end

  def index
    if current_user.admin?
      #redirect to the admin/super admin page
      redirect_to "/admin_page"
    else
      #redirect to the page for students/TA's/module leaders
      redirect_to "/modules"
    end
  end

end
