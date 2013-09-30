class WatchController < ApplicationController

  LAT_LON_OFFSET = 10000.0

  KEY_STOP_ID   = "0"
  KEY_LATITUDE  = "1"
  KEY_LONGITUDE = "2"
  KEY_ACCURACY  = "3"
  KEY_PAGE      = "4"
  KEY_BUTTON    = "5"

  skip_before_filter :verify_authenticity_token

  # POST /watch
  # GET /watch
  def index
    lat = params[KEY_LATITUDE].to_i  / LAT_LON_OFFSET
    lon = params[KEY_LONGITUDE].to_i / LAT_LON_OFFSET

    stop_id     = params[KEY_STOP_ID]
    route_index = params[KEY_PAGE]

    if stop_id == 0
      stops = Stop.near(lat, lon)

      hash = Hash[(0...stops.size).zip stops.map(&:stop_id)]
      if hash.empty?
        hash = {
          0 => 2673,
          1 => 2674,
          2 => 2675,
          3 => 2783,
          4 => 3943,
          5 => 3945
        }
      end
    else
      stop = Stop.find_by_stop_id(stop_id)

      if stop.nil?
        hash = {
          0 => "Invalid Stop",
          1 => "",
          2 => ""
        }
      else
        hash = { 0 => stop.stop_name[0,15] }
        routes = stop.routes

        if routes.count > 0
          route = routes[route_index.to_i % routes.count]

          hash[1] = route[:name][0,20]
          hash[2] = route[:departure_times].join(' ')[0,11]
        else
          hash[1] = ""
          hash[2] = "No Departures"
        end
      end
    end

    render json: hash
  end
end
