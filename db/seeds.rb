require 'json'
require 'csv'
require 'open-uri'

Call.destroy_all
Song.destroy_all
Book.destroy_all

Caller.destroy_all
Singing.destroy_all
User.destroy_all

harp = Book.create!(name:"1991 Sacred Harp")
shen = Book.create!(name:"Shenandoah Harmony")

Song.create!(name:"Fire Alarm", number:"25", book_id: harp[:id])
Song.create!(name:"Chapter X - Singing Excercises", number:"24t", book_id: harp.id)
Song.create!(name:"The Young Convert", number:"24b", book_id: harp[:id])
User.create!(email: "r@r.com", password: "123", admin: true)

song_data = open("https://s3.amazonaws.com/sacredharpsearch/SongData_Denson_1991.txt")

all_minutes = open("https://s3.amazonaws.com/sacredharpsearch/some_minutes.json")

CSV.foreach song_data, {headers: true, encoding: "MacRoman:UTF-8"} do |row|
   Song.create!(number: row["PageNum"], book_id: harp[:id], name: row["Title"], meter_name: row["MeterName"], meter_count: row["MeterCount"], song_text: row["SongText"], composer_first_name: row["Comp1First"], composer_last_name: row["Comp1Last"], composition_date: row["Comp1Date"])
end


file = File.read(all_minutes)

minutes = JSON.parse(file)

# song_ids = Hash.new
# caller_ids = Hash.new

class GetId
  attr_accessor :song_ids, :caller_ids

  def initialize
    @song_ids = Hash.new
    @caller_ids = Hash.new
  end

  def getSongId songNumber
    if !@song_ids[songNumber]
      @song_ids[songNumber] = Song.find_by!(number: songNumber)[:id]
    end
    return @song_ids[songNumber]
  end

  def getCallerId name
    if !@caller_ids[name]
      caller_id = Caller.create!(name: name)[:id]
      @caller_ids[name] = caller_id
    end
    return @caller_ids[name]
  end
end

getIds = GetId.new

minutes.each do |singing|
  
  if singing["IsDenson"] == 1
    new_singing = Singing.create!(name: singing["Name"], location: singing["Location"], date: singing["Date"])
    singing_id = new_singing[:id]

    singing["Singers"].each do |singer|
      caller_id = getIds.getCallerId singer["name"]
      singer["songs"].each do |song|
        # matches unambiguous calls
        # returns MatchData or nil
        # capture 1 is song number
        match =  /\[(\d+[tb]?)\]/.match(song)
        if match
           song_id = getIds.getSongId match[1]
           Call.create!(singing_id: singing_id, caller_id: caller_id, song_id: song_id)
        else
        # matches ambiguous calls
        # returns MatchData or nil
        # capture 1 is song number
          match = /\{(\d+[tb]?)\}/.match(song)
          if match
            song_id = Song.find_or_create_by!(number: match[1], book_id: harp[:id], name: "Ambiguous Call")[:id]
            Call.create!(singing_id: singing_id, caller_id: caller_id, song_id: song_id)
          else
            # matches corrected calls
            # returns MatchData or nil
            # capture 1 is original song number
            # capture 2 is corrected song number
            match = /\[(\d+[tb]?)\/\/(\d+[tb]?)\]/.match(song)
            if match
              song_id = getIds.getSongId match[2];
              Call.create!(singing_id: singing_id, caller_id: caller_id, song_id: song_id)
            else
              # matches uncorrectable calls
              # returns MatchData or nil
              # capture 1 is song number
              match = /<(\d+[tb]?)>/.match(song)
              if match
                song_id = Song.find_or_create!(number: match[1], book_id: harp[:id], name: "Uncorrectable Call")[:id]
                Call.create!(singing_id: singing_id, caller_id: caller_id, song_id: song_id)
              end
            end
          end
        end
      end
    end
  end
end

