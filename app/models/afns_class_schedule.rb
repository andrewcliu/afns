# app/models/afns_class_schedule.rb
class AfnsClassSchedule < ApplicationRecord
  belongs_to :afns_class

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

  def no_time_overlap
    overlapping_schedule = AfnsClassSchedule.where(day_of_week: day_of_week)
                                           .where.not(id: id) # Exclude the current record if updating
                                           .where("(start_time < ? AND end_time > ?) OR (start_time = ? AND end_time = ?)", end_time, start_time, start_time, end_time)
                                          
    if overlapping_schedule.exists?
      errors.add(:base, "The selected time slot is already occupied for this day.")
    end
  end
end