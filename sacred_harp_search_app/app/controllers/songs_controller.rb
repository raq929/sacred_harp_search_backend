class SongsController < OpenReadController
  def index
    if params[:number]
      render json: Song.find_by(number: params[:number])
    else
      render json: Song.all
    end
  end

  def show
    render json: Song.find(params[:id])
  end
end
