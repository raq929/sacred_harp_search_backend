class CallsController < OpenReadController

  def callInfo(call)
     caller = Caller.find(call.caller_id)
     singing = Singing.find(call.singing_id)
     song = Song.find(call.song_id)

     {song: {number: song.number, name: song.name}, singing: {name: singing.name, date: singing.date}, caller: caller.name}
   end

  def index
    #if its a request from a certain caller
    if params[:caller_id]
      caller_id = params[:caller_id]
      result = []
      Call.where(caller_id: caller_id).find_each do |call|
        result.push(callInfo(call))
      end
      render json: result
    #if it's a request for info on a certain singing
    elsif params[:singing_id]
      singing_id = params[:singing_id]
      result = []
      Call.where(singing_id: singing_id).find_each do |call|
        result.push(callInfo(call))
      end
      render json: result
    else
      Call.each do |call|
        result.push(callInfo(call))
      end
      render json: result
    end
  end

  def show
      caller = Caller.find(Call.find(params[:id]).caller_id)
      singing = Singing.find(Call.find(params[:id]).singing_id)
      song = Song.find(Call.find(params[:id]).song_id)

      render json: {song: song, singing: singing, caller: caller}
  end

  def create
    new_call = Call.create(call_params)
    if new_call.save
      render json: new_call, status: :created
    else
      render json: new_person.errors, status: :unprocessable_entity
    end
  end

  def update
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
