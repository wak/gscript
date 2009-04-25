# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '01606c6161fe45d578c48bfb9efed98c'

  # See ActionController::Base for details
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password").
  # filter_parameter_logging :password

  before_filter :login_check

  def logged_in?
    !!@current_actor
  end

  def login_check
    login = session[:actor_login]
    unless id
      redirect_to :controller => :actors, :action => :login
      return
    end
    @current_actor = Actor.find_by_login(session[:actor_login])
    unless @current_actor
      reset_session
      redirect_to :controller => :actors, :action => :login
    end
  end
end
