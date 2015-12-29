class CallersController < OpenReadController
  def index
    if params[:name]
      name = params[:name].strip
      caller = Caller.find_by(name: name)
      if(caller)
        render json: caller
      else
        possibleCallers = Caller.where("name like ?", "%#{name}%")
        if(possibleCallers)
          render json:  possibleCallers
        end
      end
    else
      render json: Caller.all
    end
  end

  def show
    render json: Caller.find(params[:id])
  end
end
