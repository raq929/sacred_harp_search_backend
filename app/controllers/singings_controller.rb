# require "./scripts/minutes_parser.rb"

require 'csv'
# require_relative 'denson_parse_one.rb'

def parse_minutes_shenandoah singing_id, params
    # render json: singing_id
    calls = Array.new
    book_id = Book.find_by(name:"Shenandoah Harmony")[:id]
    CSV.parse(params, {headers: true}) do |call|

      song_id = Song.find_or_create_by!(number: call["Page"], name: call["Song Title"], book_id: book_id)[:id]
      caller_id = Caller.find_or_create_by!(name: call["Name(s)"])[:id]
      new_call = Call.create!(song_id: song_id, caller_id: caller_id, singing_id: singing_id)
      calls.push(new_call)
    end
    # render json: calls
end

def parse_minutes_denson singing_id, params
  # book_id = Book.find_by(name:"1991 Sacred Harp")[:id]
  # minutes = denson_parse_one(params[:csv])
  # minutes["Singers"].each do |call|
  #   caller_id = Caller.find_or_create_by!(name: call["name"])[:id]
  #   call["songs"].each do |song|
  #     song_id = Song.find_by(number: song, book_id: book_id)[:id]
  #     Call.create!(song_id: song_id, caller_id: caller_id, singing_id: singing_id)
  #   end
  # end
end

class SingingsController < OpenReadController
  def index
    if params[:name] && params[:date]
      singing = Singing.find_by(name: params[:name], date: params[:date])
      if singing
        render json: singing
      else
        singings = Array.new
        Singing.find_each do |singing|
          singings.push(singing) if singing.name = params[:name]
        end
        render json: singings
      end
    else
    render json: Singing.all
    end
  end

  def show
    render json: Singing.find(params[:id])
  end

  def create
    new_singing = nil
    # render json: singing_params[:name]
    Singing.transaction do

      new_singing = Singing.create!(name: singing_params[:name], location: singing_params[:location], date: singing_params[:date])
      singing_id = new_singing[:id]
      if singing_params[:book] == "Shenandoah Harmony"
        parse_minutes_shenandoah(singing_id, singing_params[:csv])
      elsif singing_params[:book] == "1991 Sacred Harp"
        parse_minutes_denson(singing_id, singing_params)
      end
    end

    render json: {singing: new_singing, calls: new_singing.calls}
  end

  def update
    singing = Singing.find(singing_params[:id])
    singing.update(singing_params)
    if singing.save
      render json: singing
    else
      render json: singing.errors, status: :unprocessable_entity
    end
  end

  def destroy
    singing = Singing.find(singing_params[:id])
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
      params.require(:singing).permit([
        :name,
        :location,
        :date,
        :csv,
        :book
        ])
    end
end
