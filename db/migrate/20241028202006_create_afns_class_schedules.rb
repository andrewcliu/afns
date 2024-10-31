class CreateAfnsClassSchedules < ActiveRecord::Migration[5.2]
  def change
    create_table :afns_class_schedules do |t|
      t.references :afns_class, foreign_key: true
      t.string :day_of_week
      t.time :start_time
      t.time :end_time

      t.timestamps
    end
  end
end
