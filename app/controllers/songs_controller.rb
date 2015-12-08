class SongsController < OpenReadController
  def index
    if params[:number]
      book_id = Book.find_by!(name: params[:book]).id
      render json: Song.find_by!(number: params[:number], book_id: book_id )
    else
      render json: Song.all
    end
  end

  def show
    render json: Song.where(params[:id])
  end
end
