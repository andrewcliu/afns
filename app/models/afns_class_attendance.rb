class AfnsClassAttendance < ApplicationRecord
  belongs_to :afns_class_schedule

  validates :attendance_date, presence: true
  validates :attendance_count, numericality: { greater_than_or_equal_to: 0 }
  validates :attendance_date, uniqueness: { scope: :afns_class_schedule_id, message: "Attendance for this date already exists" }
end
