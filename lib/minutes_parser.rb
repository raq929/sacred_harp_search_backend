# require 'csv'
# require_relative 'denson_parse_one.rb'

# def parse_minutes_shenandoah singing_id, params
#     # render json: singing_id
#     book_id = Book.find_by(name:"Shenandoah Harmony")[:id]
#     CSV.foreach(params[:csv], {headers: true}) do |call|
#       song_id = Song.create_or_find_by!(number: call["Page"], name: call["Song Title"], book_id: book_id)
#       caller_id = Caller.create_or_find_by!(name: call["Name(s)"])[:id]
#       Call.create!(song_id: song_id, caller_id: caller_id, singing_id: singing_id)
#     end
# end

# def parse_minutes_denson singing_id, params
#   # book_id = Book.find_by(name:"1991 Sacred Harp")[:id]
#   # minutes = denson_parse_one(params[:csv])
#   # minutes["Singers"].each do |call|
#   #   caller_id = Caller.create_or_find_by!(name: call["name"])[:id]
#   #   call["songs"].each do |song|
#   #     song_id = Song.find_by(number: song, book_id: book_id)[:id]
#   #     Call.create!(song_id: song_id, caller_id: caller_id, singing_id: singing_id)
#   #   end
#   # end
# end




