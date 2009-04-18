class ActorsController < ApplicationController
  skip_filter(:login_check,
              :only => [:login])

  def index
    if logged_in?
      redirect_to :controller => :g_script, :action => :index
    else
      render :action => :login
    end
  end
  def login
    if !session[:actor_id].blank? && params[:change].blank?
      redirect_to :controller => :g_script, :action => :index
      return
    end
    if request.post?
      session[:actor_id] = params[:actor_id]
      redirect_to :action => :index
    end
  end
  def logout
    reset_session
    redirect_to :action => :index
  end
end
