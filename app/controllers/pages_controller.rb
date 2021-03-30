class PagesController < ApplicationController

  skip_authorization_check

  helper_method :show_team

  def home
    @current_nav_identifier = :home
  end

  def index
    if current_user.admin?
      #redirect to the admin/super admin page
      redirect_to "/admin_page"
    else
      @modules = ListModule.joins(:users).where("users.username = ?", current_user.username)
      session[:modules] = @modules
      
      #redirect to the page for students/TA's/module leaders
      redirect_to "/modules"
    end
  end

  def show_team
    puts "BOIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII"
    if params[:selected_module] != nil
      puts params[:selected_module].name
    end
    
  end

end
