class AfnsClassesController < ApplicationController
  before_action :set_afns_class, only: [:show, :edit, :update, :destroy]
  def create
    @afns_class = AfnsClass.new(afns_class_params)

    if @afns_class.save
      redirect_to admin_path, notice: 'guest agreement was successfully created.'
    else
      render :new
    end
  end
  def show
    @afns_class = AfnsClass.find(params[:id])
    @schedules = @afns_class.schedules
  end
  def new
    @afns_class = AfnsClass.new
    @afns_class.schedules.build
  end

  def edit
    @afns_class = AfnsClass.find(params[:id])
    @afns_class.schedules.build if @afns_class.schedules.empty?
  end

  def update
    if update_class_and_schedules

      redirect_to @afns_class, notice: 'Class and schedules were successfully updated.'
    else
      Rails.logger.error "Failed to update AfnsClass: #{@afns_class.errors.full_messages.join(', ')}"
      render :edit
    end
  end

  def destroy 
    thisclass = AfnsClass.find(params[:id])
    thisclass.destroy
    redirect_to admin_path, notice: 'Class was successfully deleted.'
  end


  def calendar
    start_date = params.fetch(:start_date, Date.today).to_date
    end_date = start_date.end_of_month

    @classes = AfnsClass.all.flat_map do |afns_class|
      afns_class.schedules.flat_map do |schedule|
        selected_dates = (start_date..end_date).select { |date| date.wday == AfnsClassSchedule::DAYS_OF_WEEK[schedule.day_of_week] }
        selected_dates.map { |date| { class: afns_class, date: date, start_time: schedule.start_time, end_time: schedule.end_time } }
      end
    end
  end
  private

  def set_afns_class
    @afns_class = AfnsClass.find(params[:id])
  end

  def afns_class_params
    params.require(:afns_class).permit(
      :name, :instructor, :is_active, :room,
      schedules_attributes: [:id, :day_of_week, :start_time, :end_time, :_destroy]
    )
  end

  def update_class_and_schedules
    ActiveRecord::Base.transaction do
      @afns_class.update!(afns_class_params)

      # Process repeat_days separately for each schedule
      if params[:afns_class][:schedules_attributes].present?
        params[:afns_class][:schedules_attributes].each do |_, schedule_params|
          next unless schedule_params[:repeat_days].present?

          # Loop over selected repeat days and create additional schedules
          schedule_params[:repeat_days].each do |day|
            @afns_class.schedules.create!(
              day_of_week: day,
              start_time: schedule_params[:start_time],
              end_time: schedule_params[:end_time]
            )
          end
        end
      end
    end
    true
  rescue ActiveRecord::RecordInvalid
    false
  end
end
