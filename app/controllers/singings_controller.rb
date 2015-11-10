class SingingsController < OpenReadController
  def index
    if params[:name]
      render json: Singing.find_by(name: params[:name])
    else
    render json: Singing.all
    end
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
    uploaded_io = params[:name][:location][:date][:csv]
    File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|

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
