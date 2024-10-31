class CreateAfnsClassAttendances < ActiveRecord::Migration[5.2]
  def change
    create_table :afns_class_attendances do |t|
      t.references :afns_class_schedule, foreign_key: true
      t.date :attendance_date
      t.integer :attendance_count

      t.timestamps
    end
  end
end
