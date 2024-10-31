# app/models/afns_class_schedule.rb
class AfnsClassSchedule < ApplicationRecord
  belongs_to :afns_class
  has_many :afns_class_attendances, dependent: :destroy
  after_create :populate_attendance_records

  # Maps days of the week to integer values
  DAYS_OF_WEEK = {
    "sunday" => 0,
    "monday" => 1,
    "tuesday" => 2,
    "wednesday" => 3,
    "thursday" => 4,
    "friday" => 5,
    "saturday" => 6
  }.freeze

  validates :day_of_week, uniqueness: { scope: :afns_class_id, message: "already has a schedule for this day" }
  validate :no_time_overlap

  # Additional validations for start_time and end_time (optional)
  validates :start_time, presence: true
  validates :end_time, presence: true

  private
  def populate_attendance_records
    # Automatically create attendance records based on the schedule's day_of_week
    attendance_date = next_occurrence_of(self.day_of_week)
    AfnsClassAttendance.create!(
      afns_class_schedule_id: self.id,
      attendance_date: attendance_date,
      attendance_count: 0 # Default count
    )
  end

  def next_occurrence_of(day)
  # Return nil immediately if day is nil
  return nil if day.nil?

  # Normalize day input to title case (e.g., "monday" -> "Monday")
  day = day.capitalize

  # Days of the week array for lookup
  days_of_week = %w[Sunday Monday Tuesday Wednesday Thursday Friday Saturday]
  target_day = days_of_week.index(day)

  # Return nil if day is invalid
  return nil if target_day.nil?

  # Calculate the days ahead to the target day
  today = Date.today.wday
  days_ahead = (target_day - today) % 7
  Date.today + days_ahead
  end



  def no_time_overlap
    overlapping_schedule = AfnsClassSchedule.where(day_of_week: day_of_week)
                                           .where.not(id: id) # Exclude the current record if updating
                                           .where("(start_time < ? AND end_time > ?) OR (start_time = ? AND end_time = ?)", end_time, start_time, start_time, end_time)
                                          
    if overlapping_schedule.exists?
      errors.add(:base, "The selected time slot is already occupied for this day.")
    end
  end
end