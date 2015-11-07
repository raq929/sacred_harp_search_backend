class SongsController < OpenReadController
  def index
    render json: Song.all
  end

  def show

  end

end
