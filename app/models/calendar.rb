class Calendar < ActiveRecord::Base
  has_many :trips, :primary_key => :service_id, :foreign_key => :service_id
end
