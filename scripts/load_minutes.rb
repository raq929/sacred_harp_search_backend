
require 'json'

file = File.read("data/Minutes_All.json")

minutes = JSON.parse(file)

minutes.each do |singing|
  if singing["IsDenson"] == 1
    new_singing = Singing.find_or_create_by!(name: singing["Name"], location: singing["Location"], date: singing["Date"])
    singing_id = new_singing[:id]
    singing["Singers"].each do |singer|
      caller = Caller.find_or_create_by!(name: singer["name"])
      caller_id = caller[:id]
      singer["songs"].each do |song|
        # matches unambiguous calls
        # returns MatchData or nil
        # capture 1 is song number
        match =  /\[(\d+[tb]?)\]/.match(song)
        if match
           found = Song.find_by(number: match[1])
           song_id = found[:id]
           Call.create!(singing_id: singing_id, caller_id: caller_id, song_id: song_id)
           puts "Call created - valid"
        else
        # matches ambiguous calls
        # returns MatchData or nil
        # capture 1 is song number
          match = /\{(\d+[tb]?)\}/.match(song)
          if match
            song = Song.find_or_create_by!(number: match[1], book_id: Book.find_by(name:"1991 Sacred Harp")[:id], name: "Ambiguous Call")
            Call.create!(singing_id: singing_id, caller_id: caller_id, song_id: song[:id])
            puts "Call created - ambiguous"
          else
            # matches corrected calls
            # returns MatchData or nil
            # capture 1 is original song number
            # capture 2 is corrected song number
            match = /\[(\d+[tb]?)\/\/(\d+[tb]?)\]/.match(song)
            if match
              Call.create!(singing_id: singing_id, caller_id: caller_id, song_id: Song.find_by(number: match[2])[:id])
              puts "Call created - corrected"
            else
              # matches uncorrectable calls
              # returns MatchData or nil
              # capture 1 is song number
              match = /<(\d+[tb]?)>/.match(song)
              if match
                song = Song.find_or_create!(number: match[1], book_id: Book.find_by("1991 Sacred Harp"), name: "Uncorrectable Call")
                Call.create!(singing_id: singing_id, caller_id: caller_id, song_id: song[:id])
                puts "Call created - uncorrectable"
              end
            end
          end
        end
      end
    end
  end
end


