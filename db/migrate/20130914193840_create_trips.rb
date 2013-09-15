class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|
      t.integer :route_id
      t.string  :service_id
      t.string  :trip_id
      t.string  :trip_headsign
      t.integer :direction_id
      t.integer :block_id
      t.integer :shape_id

      t.timestamps
    end
  end
end
