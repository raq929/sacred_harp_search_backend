require 'csv'

class SingingsController < OpenReadController
  include MinutesParser
  include CallInfo

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
    new_calls = nil

    begin
      Singing.transaction do

        new_singing = Singing.create!(name: singing_params[:name], location: singing_params[:location], date: singing_params[:date])
        singing_id = new_singing[:id]
        if singing_params[:book] == "Shenandoah Harmony"
          new_calls = parse_minutes_shenandoah(singing_id, singing_params[:csv])
        elsif singing_params[:book] == "1991 Sacred Harp"
          new_calls = parse_minutes_denson(singing_id, singing_params[:csv]).calls
        end
      end
    rescue ActiveRecord::RecordInvalid => invalid
      p invalid.message
      render text: invalid.message, status: 400
    rescue Exception => e
      puts e.message
      puts e.backtrace.inspect
      render text: e.message, status: 400
    else
      render json: new_calls.map {|call| callInfo(call)}
    end      
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
