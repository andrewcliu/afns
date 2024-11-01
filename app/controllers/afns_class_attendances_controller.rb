# app/controllers/afns_class_attendances_controller.rb
class AfnsClassAttendancesController < ApplicationController
  before_action :set_afns_class_schedule
  before_action :set_afns_class_attendance, only: [:edit, :update]
  before_action :require_login
  before_action :require_admin, only: [:destroy]
  # GET /afns_class_schedules/:afns_class_schedule_id/afns_class_attendances
  def index
    @attendances = @afns_class_schedule.afns_class_attendances.order(attendance_date: :desc)
  end


  def create
    @schedule = AfnsClassSchedule.find(params[:afns_class_schedule_id])
    @attendance = @schedule.afns_class_attendances.new(attendance_params)

    # Assign default values if params are missing
    @attendance.attendance_date ||= Date.today
    @attendance.attendance_count ||= 0

    if @attendance.save
      redirect_to afns_classes_path, notice: 'Attendance record created successfully.'
    else
      redirect_to afns_classes_path, alert: 'Failed to create attendance record.'
    end
  end

  def new 
    @afns_class_schedule = AfnsClassSchedule.find(params[:afns_class_schedule_id])
    @attendance = @afns_class_schedule.afns_class_attendances.new
  end

  def edit

  end


  def update
    if @attendance.update(attendance_params)
      redirect_to afns_classes_path, notice: "Attendance updated successfully."
    else
      render :edit, alert: "Failed to update attendance."
    end
  end

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
    params.fetch(:afns_class_attendance, {}).permit(:attendance_date, :attendance_count)
  end
end
