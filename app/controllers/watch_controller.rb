class WatchController < ApplicationController

  # POST /watch
  def new
    @stops = Stop.near(params[:lat], params[:lon])

    hash = @stops.inject([{}, 0]) { |(hash, i), stop|
      hash[i+=1] = "0#{stop.stop_name} (#{stop.stop_id})"
      stop.stop_info[:routes].map { |route|
        hash[i+=1] = "1#{route[:name]}"
        hash[i+=1] = "2#{route[:departure_times].join(' ')}"
      }
      [hash, i]
    }[0]

    render json: hash
  end

  # GET /watch
  def index
    @stops = Stop.near(params[:lat], params[:lon])

    hash = @stops.inject([{}, 0]) { |(hash, i), stop|
      hash[i+=1] = "0#{stop.stop_name} (#{stop.stop_id})"
      stop.stop_info[:routes].map { |route|
        hash[i+=1] = "1#{route[:name]}"
        hash[i+=1] = "2#{route[:departure_times].join(' ')}"
      }
      [hash, i]
    }[0]

    render json: hash
  end
end
