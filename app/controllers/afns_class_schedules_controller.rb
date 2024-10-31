class AfnsClassSchedulesController < ApplicationController
  before_action :set_afns_class_schedule, only: [:edit, :update, :destroy, :show_with_attendance]

  def show_with_attendance
    # Initialize a new attendance record associated with this schedule
    @attendance = @afns_class_schedule.afns_class_attendances.new
  end

  def index
    @schedules = AfnsClassSchedule.includes(:afns_class).where(afns_classes: { is_active: true })

    # Format the schedules as FullCalendar events
    @events = @schedules.map do |schedule|
      {
        title: "#{schedule.afns_class.name} (Room: #{schedule.afns_class.room})",
        start: full_calendar_datetime(schedule, schedule.start_time, schedule.day_of_week),
        end: full_calendar_datetime(schedule, schedule.end_time, schedule.day_of_week),
        description: "Instructor: #{schedule.afns_class.instructor}",
        color: '#28a745' # Customize color if needed
      }
    end
  end
  def new
    @afns_class = AfnsClass.find(params[:afns_class_id])
    @afns_class_schedule = AfnsClassSchedule.new
    @afns_class_schedule.afns_class_id = params[:afns_class_id] if params[:afns_class_id].present?

    # Fetch all classes for the dropdown
  end
def create
  temp = params[:afns_class_schedule][:repeat_days]
  repeat_days = params[:afns_class_schedule].delete(:repeat_days) || []
  start_time = DateTime.new(
    params[:afns_class_schedule]["start_time(1i)"].to_i,
    params[:afns_class_schedule]["start_time(2i)"].to_i,
    params[:afns_class_schedule]["start_time(3i)"].to_i,
    params[:afns_class_schedule]["start_time(4i)"].to_i,
    params[:afns_class_schedule]["start_time(5i)"].to_i
  )

  end_time = DateTime.new(
    params[:afns_class_schedule]["end_time(1i)"].to_i,
    params[:afns_class_schedule]["end_time(2i)"].to_i,
    params[:afns_class_schedule]["end_time(3i)"].to_i,
    params[:afns_class_schedule]["end_time(4i)"].to_i,
    params[:afns_class_schedule]["end_time(5i)"].to_i
  )
  temp.each do |day|
    AfnsClassSchedule.create!(
      afns_class_id: params[:afns_class_schedule][:afns_class_id],
      day_of_week: day,
      start_time: start_time,
      end_time: end_time
    )
  end

  # Manually assign each attribute to avoid mass assignment issues

  redirect_to afns_classes_path, notice: 'Class schedule was successfully created.'

end

  def edit
  end

  def update
    if @afns_class_schedule.update(afns_class_schedule_params_update)
      redirect_to afns_classes_path, notice: 'Class schedule was successfully updated.'
    else
      set_afns_classes
      render :edit
    end
  end

  def destroy
    @afns_class_schedule.destroy
    redirect_to afns_classes_path, notice: 'Class schedule was successfully deleted.'
  end

  private
  def set_afns_class_schedule
    @afns_class_schedule = AfnsClassSchedule.find(params[:id])
  end
  def full_calendar_datetime(schedule, time, day_of_week)
    # Get the numeric day of the week from DAYS_OF_WEEK or return nil if invalid
    target_weekday = AfnsClassSchedule::DAYS_OF_WEEK[day_of_week]

    # Return nil if day_of_week is not valid
    return nil unless target_weekday

    # Calculate the next occurrence of the specified day
    today = Date.today
    target_date = today + ((target_weekday - today.wday) % 7)
    DateTime.new(target_date.year, target_date.month, target_date.day, time.hour, time.min, time.sec)
  end

  def set_afns_class_schedule
    @afns_class_schedule = AfnsClassSchedule.find(params[:id])
  end

  def set_afns_classes
    @afns_classes = AfnsClass.all
  end
  def afns_class_schedule_params
    params.require(:afns_class_schedule).permit(:afns_class_id, :day_of_week, :start_time, :end_time)
  end


def process_repeat_days(class_schedule, repeat_days)
  # Create duplicate schedules for each selected repeat day
  repeat_days.each do |day|
    AfnsClassSchedule.create!(
      afns_class_id: class_schedule.afns_class_id,
      day_of_week: day,
      start_time: class_schedule.start_time,
      end_time: class_schedule.end_time
    )
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error "Error creating duplicate schedule for #{day}: #{e.message}"
  end
end
end
