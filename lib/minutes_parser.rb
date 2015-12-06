require 'csv'
require './denson_parse_one.rb'

def parse_minutes_shenandoah singing_id, csv
    # render json: singing_id
    calls = Array.new
    book_id = Book.find_by(name:"Shenandoah Harmony")[:id]

    CSV.parse(csv, {headers: true}) do |call|

        song_id = Song.find_or_create_by!(number: call["Page"], name: call["Song Title"], book_id: book_id)[:id]
        caller_id = Caller.find_or_create_by!(name: call["Name(s)"])[:id]

        new_call = Call.create!(song_id: song_id, caller_id: caller_id, singing_id: singing_id)
        calls.push(new_call)
    
        
    end
    render json: {calls: calls}
end

def parse_minutes_denson singing_id, csv
  puts "singing id = ", singing_id
  book_id = Book.find_by(name:"1991 Sacred Harp")[:id]
  minutes = denson_parse_one(csv)
  minutes["Singers"].each do |call|
  def create_call_for_existing_song song_number, caller_id, singing_id
    found = Song.find_by!(number: song_number)
    song_id = found[:id]
    Call.create!(singing_id: singing_id, caller_id: caller_id, song_id: song_id)
  end

  caller_id = Caller.find_or_create_by!(name: call["name"])[:id]
  call["songs"].each do |song|
    # matches unambiguous calls
      # returns MatchData or nil
      # capture 1 is song number
      match =  /\[(\d+[tb]?)\]/.match(song)
      if match 
         create_call_for_existing_song match[1], caller_id, singing_id
      else
      # matches ambiguous calls
      # returns MatchData or nil
      # capture 1 is song number
        match = /\{(\d+[tb]?)\}/.match(song)
        if match
          song = Song.find_or_create_by!(number: match[1], book_id: book_id, name: "Ambiguous Call")
          Call.create!(singing_id: singing_id, caller_id: caller_id, song_id: song[:id])
        else
          # matches corrected calls
          # returns MatchData or nil
          # capture 1 is original song number
          # capture 2 is corrected song number
          match = /\[(\d+[tb]?)\/\/(\d+[tb]?)\]/.match(song)
          if match
            create_call_for_existing_song match[2], caller_id, singing_id
          else
            # matches uncorrectable calls
            # returns MatchData or nil
            # capture 1 is song number
            match = /<(\d+[tb]?)>/.match(song)
            if match
              song = Song.find_or_create!(number: match[1], book_id: book_id, name: "Uncorrectable Call")
              Call.create!(singing_id: singing_id, caller_id: caller_id, song_id: song[:id])
            end
          end
        end
      end
    end
  end
end


