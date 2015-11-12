class CallsController < OpenReadController

  def callInfo(call)
     caller = Caller.find(call.caller_id)
     singing = Singing.find(call.singing_id)
     song = Song.find(call.song_id)

     {song: {number: song.number, name: song.name, book: song.book}, singing: {name: singing.name, location: singing.location, date: singing.date, id: singing.id}, caller: caller.name}
  end

  def index
    #if its a request from a certain caller
    result = []
    if params[:caller_id]
      caller_id = params[:caller_id]
      Call.where(caller_id: caller_id).find_each do |call|
        result.push(callInfo(call))
      end
    #if it's a request for info on a certain singing
    elsif params[:singing_id]
      singing_id = params[:singing_id]
      Call.where(singing_id: singing_id).find_each do |call|
        result.push(callInfo(call))
      end
    elsif params[:song_id]
      song_id = params[:song_id]
      Call.where(song_id: song_id).find_each do |call|
        result.push(callInfo(call))
      end
    else
      result.push(Call.all)
    end
    render json: result
  end

  def show
      caller = Caller.find(Call.find(params[:id]).caller_id)
      singing = Singing.find(Call.find(params[:id]).singing_id)
      song = Song.find(Call.find(params[:id]).song_id)

      render json: {song: song, singing: singing, caller: caller}
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
