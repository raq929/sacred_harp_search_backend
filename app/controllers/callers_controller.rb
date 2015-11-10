class CallersController < OpenReadController
  def index
    if params[:name]
      render json: Caller.find_by(name: params[:name])
    else
      render json: Caller.all
    end
  end

  def show
    render json: Caller.find(params[:id])
  end
end
