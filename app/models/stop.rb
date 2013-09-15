class Stop < ActiveRecord::Base
  has_many :stop_times, :primary_key => :stop_id

  RADIUS = 0.004

  scope :near, lambda { |lat, lon|
    where("stop_lat BETWEEN ? AND ?", lat.to_f - RADIUS, lat.to_f + RADIUS).
    where("stop_lon BETWEEN ? AND ?", lon.to_f - RADIUS, lon.to_f + RADIUS)
  }

  def stop_info
    {
      :stop_id    => stop_id,
      :stop_name  => stop_name,
      :stop_lat   => stop_lat,
      :stop_lon   => stop_lon,
      :routes     => stop_times.upcoming.inject({}) { |hash, stop_time|
          if stop_time.trip.active
            hash[stop_time.trip.trip_headsign] ||= []
            hash[stop_time.trip.trip_headsign] << stop_time.departure_time.strftime("%R")
          end
          hash
        }.inject([]) { |array, (key, times)| 
          array << { :name => key, :departure_times => times.sort }
          array
        }
    }
  end

end
