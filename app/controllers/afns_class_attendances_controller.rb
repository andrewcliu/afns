# app/controllers/afns_class_attendances_controller.rb
class AfnsClassAttendancesController < ApplicationController
  before_action :set_afns_class_schedule
  before_action :set_afns_class_attendance, only: [:edit, :update]

  # GET /afns_class_schedules/:afns_class_schedule_id/afns_class_attendances
  def index
    @attendances = @afns_class_schedule.afns_class_attendances.order(attendance_date: :desc)
  end

  # POST /afns_class_schedules/:afns_class_schedule_id/afns_class_attendances
  def create
    @attendance = @afns_class_schedule.afns_class_attendances.new(attendance_params)
    @attendance.attendance_date ||= Date.today # Default to today if no date is provided

    if @attendance.save
      redirect_to afns_classes_path, notice: "Attendance recorded successfully."
    else
      render :new, alert: "Failed to record attendance."
    end
  end
  def edit
    # The @attendance instance variable is set by the set_afns_class_attendance method
  end

  # PATCH/PUT /afns_class_schedules/:afns_class_schedule_id/afns_class_attendances/:id
  def update
    if @attendance.update(attendance_params)
      redirect_to afns_classes_path, notice: "Attendance updated successfully."
    else
      render :edit, alert: "Failed to update attendance."
    end
  end
  # GET /afns_class_schedules/:afns_class_schedule_id/afns_class_attendances/:id
  def show
    @attendance = @afns_class_schedule.afns_class_attendances.find(params[:id])
  end

  private

  def set_afns_class_schedule
    @afns_class_schedule = AfnsClassSchedule.find(params[:afns_class_schedule_id])
  end

  def set_afns_class_attendance
    @attendance = @afns_class_schedule.afns_class_attendances.find(params[:id])
  end

  def attendance_params
    params.require(:afns_class_attendance).permit(:attendance_date, :attendance_count)
  end
end
