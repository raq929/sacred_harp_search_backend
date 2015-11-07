#!/usr/bin/ruby -rpp -rcsv -rjson
## Emacs: -*- tab-width: 4; -*- vi: tabstop=4

# Parse singers and songs led from Minutes data in Merge format.
# Assumes the data is arriving on stdin (with MacRoman encoding and
# Mac line endings (using CSV module's automatic line ending mode).

# Recognizes only song numbers that have been previously identified as
# likely Denson songs and thus marked up with [xxx] or {xxx} or
# [xxx//xxx].

def run
  
  # Definition of format for parsing people's names and songs:

  songnum			= %r{\d{2,3}[tb]?}								# 24 or 306 or 306t or 95b
  song_markup		= %r{(?:\[#{songnum}\]) |						# [306t]
					     (?:\{#{songnum}\}) |						# {306}
					     (?:\[#{songnum}//#{songnum}\])				# [306//306t]
					    }x
  song_sequence		= %r{#{song_markup}(?:(?:, ?#{song_markup})*)}	# [28], {29} ... etc.
  name_part			= %r{(?:[[:upper:]][[:alpha:]\.\-\']*)}			# B or B. or B.G. or Bill or BILL but not 'bill'
  person_name		= %r{#{name_part}(?:(?: #{name_part})*)}		# One or more name_part separated by spaces
  singer_match		= %r{(#{person_name}) (#{song_sequence})}		# A name followed by a list of songs
  
  # Parse...

  fieldnames		= nil
  recnum			= 0
  
  CSV.parse(STDIN.set_encoding("MacRoman:utf-8").read, {:col_sep => "\t"}).each{|row| 

	# Read the header row
	begin fieldnames = row; next end unless fieldnames 
	
	# Read regular rows, decoding embedded newlines, removing " "
	# around fields, and parsing values that appear to be floats or
	# integers.

	# Not handling encoding of " as "" inside field values because
	# that does not occur in the input data, although it is part of
	# the spec for "Merge" format.

	rec 			= Hash[fieldnames.zip(row.map{|i| 
											i.gsub!(/\x0B/, "\n") 				# Merge format newlines embedded as ASCII 11 (Control-K aka \x0B).
											i.gsub!(/^\"?(.*)\"$/m, "\\1") 		# Trim leading and trailing quotes.
											i = ( i.valid_int?   ? Integer(i) :	# Convert to int or float if possible.
												 (i.valid_float? ?   Float(i) : i))
										  })]
	
	## DEBUG: $stderr.puts "#{recnum += 1} / #{rec['Date']} / #{rec['Name']} / #{rec['Location']}"
	
	# Add a "Singers" field to the record by parsing the Minutes
	# field.  It will be a list of records of singers with 'name' and
	# 'songs', which itself will be a list of song markups.
	
	minutes			= rec["Minutes"]
	
	singers_raw		= minutes.scan(singer_match)

	rec['Singers']	= singers_raw.map{|pair|
	  name, songs 	= pair
	  songlist		= songs.scan(song_markup).flatten
	  info			= {
		'name' 		=> name, 
		# 'songs_raw'	=> songs, 
		'songs' 	=> songlist,
	  }
	}

	# Output as json, in 'pretty' format for easier reading.
	puts JSON.pretty_generate(rec)
  }
end

# Create some 'missing' ruby methods.  A bug found in ruby 2.0.0 makes
# it unreliable to use simple regex matching to do this
# type-convertability checking.

class Object; def valid_int?;   !!Integer(self)	rescue false; end; end
class Object; def valid_float?;   !!Float(self)	rescue false; end; end

###

run
