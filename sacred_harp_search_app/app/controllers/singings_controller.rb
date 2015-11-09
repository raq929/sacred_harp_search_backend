class SingingsController < OpenReadController
  def index
    render json: Singing.all
  end

  def show
    render json: Singing.find(params[:id])
  end

  def create
    singing = Singing.create!(name: singing_params[:name], location: singing_params[:location], date: singing_params[:date])
    if singing.save
      render json: singing
    else
      render json: singing.errors, status: :unprocessable_entity
    end
  end

private
   def singing_params
    params.require(:singing).permit([
      :name,
      :location,
      :date
      ])
  end
end
