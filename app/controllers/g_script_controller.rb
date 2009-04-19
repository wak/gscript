class GScriptController < ApplicationController
  def index
    @readies = Ready.find(:all)
  end
  def startup
    @action = GScript.action(params[:gaction])
    @base = {
      :action => @action.info(:iname)
    }
    do_common
  end

  def ready
    @ready = Ready.find(params[:ready_id])
    @action = GScript.action(@ready.action)
    @action._gs_load(@ready)
    @action.ready = params[:selected]
    @base = {
      :action => @action.info(:iname)
    }
    do_common
  rescue ActiveRecord::RecordNotFound
    render :text => 'Ready Not Found.'
  end

  def init_actions
    GScript.init_actions
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
          return
        else
          inputed = true
          params.each {|key, val|
            @action._gs_input_set(key, val)
          }
          @params = params
          unless @action._gs_input_valid?
            render :action => :input
            return
          end
          # not return
        end
      when :ready
        @ready = @action._gs_save
        render :action => :ready
        return
      when :finish
        @ready.destroy if @ready
        render :action => :finish
        return
      when :send_file
        @file = @action._gs_status.option(:file)
        send_file(@file.public_filename,
                  :filename => @file.filename,
                  :type => @file.content_type,
                  :disposition => 'inline')
        return
      else
        render :text => "Bad GScript status(=#{@action._gs_status.mode})"
        return
      end
    end
  end
end
