class AfnsClassSchedulesController < ApplicationController
  before_action :set_afns_class_schedule, only: [:new, :edit, :update, :destroy]

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
    @afns_class_schedule = AfnsClassSchedule.new
    @afns_class_schedule.afns_class_id = params[:afns_class_id] if params[:afns_class_id].present?

    # Fetch all classes for the dropdown
    @afns_classes = AfnsClass.all.reject{|e|e.schedules.present?}
  end
  def create
   @class_schedule = AfnsClassSchedule.new(afns_class_schedule_params)

    if @class_schedule.save
      # Process repeat days after the initial save
      process_repeat_days(@class_schedule)
      redirect_to @class_schedule.afns_class, notice: 'Class schedule was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @afns_class_schedule.update(afns_class_schedule_params)
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

  def process_repeat_days(class_schedule)
    # Check if repeat_days is present in the form submission
    if params[:afns_class_schedule][:repeat_days].present?
      valid_days = params[:afns_class_schedule][:repeat_days]
      valid_days.each do |day|

        # Create duplicate schedules for each selected repeat day
        AfnsClassSchedule.create!(
          afns_class_id: class_schedule.afns_class_id,
          day_of_week: day,
          start_time: class_schedule.start_time,
          end_time: class_schedule.end_time
        )
      end
    end
  end
end
