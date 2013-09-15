class CreateCalendars < ActiveRecord::Migration
  def change
    create_table :calendars do |t|
      t.string    :service_id
      t.integer   :monday
      t.integer   :tuesday
      t.integer   :wednesday
      t.integer   :thursday
      t.integer   :friday
      t.integer   :saturday
      t.integer   :sunday
      t.date      :start_date
      t.date      :end_date

      t.timestamps
    end
  end
end
