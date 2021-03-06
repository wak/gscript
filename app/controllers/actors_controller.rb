class ActorsController < ApplicationController
  skip_filter :login_check, :only => :login

  def index
    if logged_in?
      redirect_to :controller => :g_script, :action => :index
    else
      render :action => :login
    end
  end
  def login
    if !session[:actor_login].blank? && params[:change].blank?
      redirect_to gscript_path
      return
    end
    if request.post?
      session[:actor_login] = params[:actor_login]
      redirect_to root_path
    end
  end
  def logout
    reset_session
    redirect_to root_path
  end
end
