class Trip < ActiveRecord::Base
  belongs_to :route, :foreign_key => :route_id
  belongs_to :calendar, :primary_key => :service_id, :foreign_key => :service_id
  has_many :stop_times, :primary_key => :trip_id
end
