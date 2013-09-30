class StopsController < ApplicationController

  # GET /stops
  def index
    @stops = Stop.near(params[:lat], params[:lon])

    respond_to do |format|
      format.html
      format.json { 
        render json: {
          stops: @stops.map(&:stop_info)
        }
      }
    end
  end

  # GET /stops/:id
  def show
    @stop = Stop.find_by_stop_id(params[:id])

    render json: @stop.stop_info
  end
end
