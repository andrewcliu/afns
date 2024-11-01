class AfnsClassSchedulesController < ApplicationController
  before_action :set_afns_class_schedule, only: [:destroy, :show_with_attendance]
  before_action :set_schedule, only: [:edit, :update]
  before_action :require_login, except: :index
  before_action :require_admin, only: [:destroy]
  def show_with_attendance
    @attendance = @afns_class_schedule.afns_class_attendances.new
  end

  def index
    @schedules = AfnsClassSchedule.includes(:afns_class).where(afns_classes: { is_active: true })
    repeat_weeks = 45 

    @events = @schedules.flat_map do |schedule|
      (0...repeat_weeks).map do |i|
        start_time = full_calendar_datetime(schedule, schedule.start_time, schedule.day_of_week).advance(weeks: i)
        end_time = full_calendar_datetime(schedule, schedule.end_time, schedule.day_of_week).advance(weeks: i)
        formatted_start_time = schedule.start_time.strftime("%-I:%M")
        formatted_end_time = schedule.end_time.strftime("%-I:%M")

        {
          title: "#{schedule.afns_class.name} @ #{schedule.afns_class.room}",
          start: start_time.iso8601,
          end: end_time.iso8601,
          description: "#{schedule.afns_class.instructor} #{formatted_start_time} - #{formatted_end_time}",
          color: '#28a745'
        }
      end
    end

    respond_to do |format|
      format.html
      format.json { render json: @events } # JSON endpoint
    end
  end

  def new
    @afns_class = AfnsClass.find(params[:afns_class_id])
    @afns_class_schedule = AfnsClassSchedule.new
    @afns_class_schedule.afns_class_id = params[:afns_class_id] if params[:afns_class_id].present?
  end

  def create

    temp = params[:afns_class_schedule][:repeat_days]
    repeat_days = params[:afns_class_schedule].delete(:repeat_days) || []
    start_time = Time.new(
      2000, 1, 1, # Arbitrary year, month, day
      params[:afns_class_schedule]["start_time(4i)"].to_i,
      params[:afns_class_schedule]["start_time(5i)"].to_i
    )

    end_time = Time.new(
      2000, 1, 1, # Arbitrary year, month, day
      params[:afns_class_schedule]["end_time(4i)"].to_i,
      params[:afns_class_schedule]["end_time(5i)"].to_i
    )
    temp.each do |day|
      AfnsClassSchedule.create!(
        afns_class_id: params[:afns_class_schedule][:afns_class_id],
        day_of_week: day,
        start_time: start_time.utc.iso8601,
        end_time: end_time.utc.iso8601
      )
    end

    redirect_to afns_classes_path, notice: 'Class schedule was successfully created.'

  end

  def edit
    @one_schedule
  end

  def update
    if @one_schedule.update(afns_class_schedule_params)
      redirect_to afns_class_path(@one_schedule.afns_class), notice: "Schedule was successfully updated."
    else
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
    target_weekday = AfnsClassSchedule::DAYS_OF_WEEK[day_of_week]
    return DateTime.now unless target_weekday && time

    today = Date.today
    days_until_target = (target_weekday - today.wday) % 7
    target_date = today + days_until_target

    # Combine date and time, then convert to UTC
    DateTime.new(target_date.year, target_date.month, target_date.day, time.hour, time.min, time.sec).utc
  end

  def set_afns_class_schedule
    @afns_class_schedule = AfnsClassSchedule.find(params[:id])
  end

  def set_schedule
    @one_schedule = AfnsClassSchedule.find(params[:id])
  end
  def set_afns_classes
    @afns_classes = AfnsClass.all
  end
  def afns_class_schedule_params
    params.require(:afns_class_schedule).permit(:afns_class_id, :day_of_week, :start_time, :end_time)
  end


end
