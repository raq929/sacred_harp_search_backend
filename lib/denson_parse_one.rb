module DensonParseOne
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
   
    CSV.parse(text, {headers: false, :col_sep => "\t"}).each do |row|

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

      singers_raw   = minutes.scan(singer_match)

      rec['Singers']  = singers_raw.map{|pair|
        name, songs   = pair
        songlist    = songs.scan(song_markup).flatten
        info      = {
        'name'    => name,
        # 'songs_raw' => songs,
        'songs'   => songlist,
        }
      }


    end
    rec
  end
end  
