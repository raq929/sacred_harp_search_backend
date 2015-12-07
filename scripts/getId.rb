class GetId
  attr_accessor :song_ids, :caller_ids

  def initialize
    @song_ids = Hash.new
    @caller_ids = Hash.new
  end

  def getSongId songNumber
    if !@song_ids[songNumber]
      @song_ids[songNumber] = Song.find_by!(songNumber)[:id]
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

g = GetId.new
