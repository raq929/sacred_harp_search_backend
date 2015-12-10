module CallInfo
  extend ActiveSupport::Concern 
  def callInfo(call)
     caller = Caller.find(call.caller_id)
     singing = Singing.find(call.singing_id)
     song = Song.find(call.song_id)

     {book: song.book, song: {number: song.number, name: song.name}, singing: {name: singing.name, location: singing.location, date: singing.date, id: singing.id}, caller: caller.name}
  end
end
