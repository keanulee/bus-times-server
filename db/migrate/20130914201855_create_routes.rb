class CreateRoutes < ActiveRecord::Migration
  def change
    create_table :routes do |t|
      t.integer   :route_id
      t.string    :route_short_name
      t.string    :route_long_name
      t.string    :route_desc
      t.integer   :route_type
      t.string    :route_url

      t.timestamps
    end
  end
end
