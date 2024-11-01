class AfnsClass < ApplicationRecord
	has_one :waiver
  has_many :schedules, class_name: 'AfnsClassSchedule', dependent: :destroy
  has_many :afns_class_schedules
  validates :name, presence: true
  validates :instructor, presence: true
  validates :room, presence: true

  accepts_nested_attributes_for :schedules, allow_destroy: true, update_only: true
  
  ROOMS = [
    { id: 1, name: 'Studio 1' },
    { id: 2, name: 'Studio 2' },
    { id: 3, name: 'Pool' },
    { id: 4, name: 'Pilates Room' },
    { id: 5, name: 'Court 9' }
  ].freeze
  def occurrence_dates(start_date, end_date)
    schedules.flat_map do |schedule|
      selected_dates = (start_date..end_date).select { |date| date.wday == AfnsClassSchedule::DAYS_OF_WEEK[schedule.day_of_week] }
      selected_dates.map { |date| { date: date, start_time: schedule.start_time, end_time: schedule.end_time } }
    end
  end
end



