class AfnsClassAttendance < ApplicationRecord
  belongs_to :afns_class_schedule

  validates :attendance_date, presence: true
  validates :attendance_count, numericality: { greater_than_or_equal_to: 0 }
end
