class StopTime < ActiveRecord::Base
  belongs_to :stop, :primary_key => :stop_id
  belongs_to :trip, :primary_key => :trip_id

  scope :upcoming, lambda {
    now   = Time.zone.now
    later = 60.minutes.from_now

    # day is a field name, so we can't use "safe" SQL passing
    day = now.strftime("%A").downcase

    if now.beginning_of_day < later.beginning_of_day
      joins(:trip => :calendar)
      .includes(:trip).references(:trip)
      .where("departure_time BETWEEN ? AND '23:59'", now.strftime("%R"))
      .where("calendars." + day + " = 1")
    else
      joins(:trip => :calendar)
      .includes(:trip).references(:trip)
      .where("departure_time BETWEEN ? AND ?", now.strftime("%R"), later.strftime("%R"))
      .where("calendars." + day + " = 1")
    end
  }
end
