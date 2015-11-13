require 'json'
require 'csv'

Call.destroy_all
Song.destroy_all
Book.destroy_all

Caller.destroy_all
Singing.destroy_all
User.destroy_all

harp = Book.create!(name:"1991 Sacred Harp")
shen = Book.create!(name:"Shenandoah Harmony")

Song.create!(name:"Fire Alarm", number:"25", book: harp[:id])
Song.create!(name:"Chapter X - Singing Excercises", number:"24t", book: harp.id)
Song.create!(name:"The Young Convert", number:"24b", book: harp[:id])
User.create!(email: "r@r.com", password: "123", admin: true, book: harp[:id])



CSV.parse "https://s3.amazonaws.com/sacredharpsearch/SongData_Denson_1991.txt", {headers: true, encoding: "MacRoman:UTF-8"} do |row|
   Song.find_or_create_by!(number: row["PageNum"], book_id: shen[:id], name: row["Title"], meter_name: row["MeterName"], meter_count: row["MeterCount"], song_text: row["SongText"], composer_first_name: row["Comp1First"], composer_last_name: row["Comp1Last"], composition_date: row["Comp1Date"], poet_first_name: row["Poet1First"], poet_last_name: row["Poet1Last"])
end


file = File.read("https://s3.amazonaws.com/sacredharpsearch/Minutes_All.json")

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
        else
        # matches ambiguous calls
        # returns MatchData or nil
        # capture 1 is song number
          match = /\{(\d+[tb]?)\}/.match(song)
          if match
            song = Song.find_or_create_by!(number: match[1], book_id: harp[:id], name: "Ambiguous Call")
            Call.create!(singing_id: singing_id, caller_id: caller_id, song_id: song[:id])
          else
            # matches corrected calls
            # returns MatchData or nil
            # capture 1 is original song number
            # capture 2 is corrected song number
            match = /\[(\d+[tb]?)\/\/(\d+[tb]?)\]/.match(song)
            if match
              Call.create!(singing_id: singing_id, caller_id: caller_id, song_id: Song.find_by(number: match[2])[:id])
            else
              # matches uncorrectable calls
              # returns MatchData or nil
              # capture 1 is song number
              match = /<(\d+[tb]?)>/.match(song)
              if match
                song = Song.find_or_create!(number: match[1], book_id: harp[:id], name: "Uncorrectable Call")
                Call.create!(singing_id: singing_id, caller_id: caller_id, song_id: song[:id])
              end
            end
          end
        end
      end
    end
  end
end

