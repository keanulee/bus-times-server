class StopTime < ActiveRecord::Base
  belongs_to :stop, :primary_key => :stop_id
  belongs_to :trip, :primary_key => :trip_id

  scope :upcoming, lambda {
    now   = Time.now
    later = Time.now + 60.minutes

    if now.beginning_of_day < later.beginning_of_day
      where("departure_time BETWEEN ? AND '23:59'", now.strftime("%R"))
    else
      where("departure_time BETWEEN ? AND ?", now.strftime("%R"), later.strftime("%R"))
    end
  }
end
