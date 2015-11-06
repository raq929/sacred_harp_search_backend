class CallersController < OpenReadController
  def index
    render json: Caller.all
  end
  def show
    render json: Caller.find(params[:id]).songs
  end
end
