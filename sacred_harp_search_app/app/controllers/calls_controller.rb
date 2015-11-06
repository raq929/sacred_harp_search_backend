class CallsController < OpenReadController
  def index
    render json: Call.all
  end

  def show
      caller = Caller.find(Call.find(params[:id]).caller_id)
      singing = Singing.find(Call.find(params[:id]).singing_id)
      song = Song.find(Call.find(params[:id]).song_id)

      render json: {song: song, singing: singing, caller: caller}
  end

  def update
    new_call = Call.create(call_params)
    if new_call.save
      render json: new_call, status: :created
    else
      render json: new_person.errors, status: :unprocessable_entity
    end
  end

  def create
  end

  def destroy
  end

  private
  def calls_params
    params.require(:call).permit([
      :caller_id,
      :singing_id,
      :song_id
      ])
  end

end
