class GScriptController < ApplicationController
  layout 'appli'
  skip_filter :login_check, :only => :init_db

  def index
    @title = 'GScript Index'
    @readies = Ready.find(:all)
  end
  def start
    @action = GScript::GsActionSpace.action(params[:gaction])
    @base = {
      :action => @action._gs_info(:iname)
    }
    do_common
  end

  def ready
    @ready = Ready.find(params[:id])
    @action = GScript.action(@ready.action)
    @action._gs_load(@ready)
    @action.ready = params[:selected]
    @base = {
      :action => @action._gs_info(:iname)
    }
    do_common
  rescue ActiveRecord::RecordNotFound
    render :text => 'Ready Not Found.'
  end

  def init_db
    GScript::GsDB.init_db
    redirect_to :action => :index
  end

  def cancel
    @log = ActionLog.find(params[:id])
    ActiveRecord::Base.transaction do
      @log.changes.each {|change|
        item = change.item
        item.value -= (change.after_value - change.before_value)
        item.save!
      }
      @log.canceled = true
      @log.save!
    end
    redirect_to :action => :index
  end

  private
  def do_common
    @action.current = @current_actor
    inputed = false
    loop do
      case @action._gs_execute
      when :input
        if inputed || request.get?
          render :action => :input
          break
        else
          inputed = true
          params.each {|key, val|
            @action._gs_input_set(key, val)
          }
          @params = params
          unless @action._gs_input_valid?
            render :action => :input
            break
          end
          # not break
        end
      when :ready
        @ready = @action._gs_save
#        @action.status.log.write
        render :action => :ready
        break
      when :finish, :cancel
        @ready.destroy if @ready
 #       @action.status.log.write
        render :action => :finish
        break
      when :send_file
        @file = @action._gs_status.option(:file)
        send_file(@file.public_filename,
                  :filename => @file.filename,
                  :type => @file.content_type,
                  :disposition => 'inline')
        break
      else
        render :text => "Bad GScript status(=#{@action._gs_status.mode})"
        break
      end
    end
  end
end
