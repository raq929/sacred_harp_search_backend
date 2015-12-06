# require "./scripts/minutes_parser.rb"

require 'csv'
# require './scripts/denson_parse_one.rb'

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

  book_id = Book.find_by(name:"1991 Sacred Harp")[:id]
  minutes = denson_parse_one(csv)
  # render json: minutes
  # minutes["Singers"].each do |call|
  #   caller_id = Caller.find_or_create_by!(name: call["name"])[:id]
  #   call["songs"].each do |song|
  #     song_id = Song.find_by(number: song, book_id: book_id)[:id]
  #     Call.create!(song_id: song_id, caller_id: caller_id, singing_id: singing_id)
  #   end
  # end
end

def denson_parse_one text
  
  # Definition of format for parsing people's names and songs:
  songnum     = %r{\d{2,3}[tb]?}                # 24 or 306 or 306t or 95b
  song_markup   = %r{(?:\[#{songnum}\]) |           # [306t]
               (?:\{#{songnum}\}) |           # {306}
               (?:\[#{songnum}//#{songnum}\])       # [306//306t]
              }x
  song_sequence   = %r{#{song_markup}(?:(?:, ?#{song_markup})*)}  # [28], {29} ... etc.
  name_part     = %r{(?:[[:upper:]][[:alpha:]\.\-\']*)}     # B or B. or B.G. or Bill or BILL but not 'bill'
  person_name   = %r{#{name_part}(?:(?: #{name_part})*)}    # One or more name_part separated by spaces
  singer_match    = %r{(#{person_name}) (#{song_sequence})}   # A name followed by a list of songs

  # Parse...

  fieldnames    = nil
  recnum      = 0
  rec = nil
  count = 0
  CSV.parse(text, {headers: false, :col_sep => "\t"}).each do |row|
    count +=1
    # Read the header row
    begin fieldnames = row; next end unless fieldnames
  
    # Read regular rows, decoding embedded newlines, removing " "
    # around fields, and parsing values that appear to be floats or
    # integers.

    # Not handling encoding of " as "" inside field values because
    # that does not occur in the input data, although it is part of
    # the spec for "Merge" format.

    rec       = Hash[fieldnames.zip(row.map{|i|
                        i.gsub!(/\x0B/, "\n")         # Merge format newlines embedded as ASCII 11 (Control-K aka \x0B).
                        i.gsub!(/^\"?(.*)\"$/m, "\\1")    # Trim leading and trailing quotes.
                        i = ( (i.is_a? Integer )  ? Integer(i) : # Convert to int or float if possible.
                           ((i.is_a? Float) ?   Float(i) : i))
                        })]

    ## DEBUG: $stderr.puts "#{recnum += 1} / #{rec['Date']} / #{rec['Name']} / #{rec['Location']}"

    # Add a "Singers" field to the record by parsing the Minutes
    # field.  It will be a list of records of singers with 'name' and
    # 'songs', which itself will be a list of song markups.

    minutes     = rec["Minutes"]

    # singers_raw   = minutes.scan(singer_match)

    # rec['Singers']  = singers_raw.map{|pair|
    #   name, songs   = pair
    #   songlist    = songs.scan(song_markup).flatten
    #   info      = {
    #   'name'    => name,
    #   # 'songs_raw' => songs,
    #   'songs'   => songlist,
    #   }
    # }
  end
  p "Count = ", count
end

class SingingsController < OpenReadController
  def index
    if params[:name]
        singings_by_name = Array.new
        Singing.find_each do |s|
          singings_by_name.push(s) if s.name == params[:name]
        end
        render json: singings_by_name
    else
      render json: Singing.all
    end
  end

  def show
    render json: Singing.find(params[:id])
  end

  def create
    new_singing = nil

    begin
      Singing.transaction do

        new_singing = Singing.create!(name: singing_params[:name], location: singing_params[:location], date: singing_params[:date])
        singing_id = new_singing[:id]
        if singing_params[:book] == "Shenandoah Harmony"
          parse_minutes_shenandoah(singing_id, singing_params[:csv])
        elsif singing_params[:book] == "1991 Sacred Harp"
          parse_minutes_denson(singing_id, singing_params[:csv])
        end
      end
    rescue ActiveRecord::RecordInvalid => invalid
      p invalid.message
      render text: invalid.message, status: 400
    rescue Exception => e
      puts e.message
      puts e.backtrace.inspect
    end  

    # render json: {singing: new_singing, calls: new_singing.calls}
  end

  def update
    singing = Singing.find(params[:id])
    singing.update(singing_params)
    if singing.save
      render json: singing
    else
      render json: singing.errors, status: :unprocessable_entity
    end
  end

  def destroy
    singing = Singing.find(params[:id])
    singing.calls.each do |call|
      call.destroy
    end
    if singing.destroy
      head :no_content
    else
      render json: singing.errors, status: :unprocessable_entity
    end
  end

  def upload
    uploaded_io = singing_params[:name][:location][:date][:csv]
    File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|

    end
  end

  private
     def singing_params
      params.require(:singing).permit(
        :name,
        :location,
        :date,
        :csv,
        :book
        )
    end
end
