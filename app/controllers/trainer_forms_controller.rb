# app/controllers/trainer_forms_controller.rb
class TrainerFormsController < ApplicationController
  before_action :set_trainer_form, only: [:show, :edit, :update, :destroy]
  before_action :require_login, except: [:new, :create]
  before_action :require_admin, only: [:destroy, :update]

  # GET /trainer_forms
  def index
    @trainer_forms = TrainerForm.all
  end

  # GET /trainer_forms/:id
  def show
  end

  # GET /trainer_forms/new
  def new
    @trainer_form = TrainerForm.new
  end

  def create
    @trainer_form = TrainerForm.new(trainer_form_params)
    
    # Append "Other" reason if provided
    if params[:trainer_form][:reasons]
      reasons = params[:trainer_form][:reasons]
      other_reason = params[:trainer_form][:other_reason]
      reasons << other_reason if other_reason.present?
      @trainer_form.reasons = reasons.join(';')
    end

    if @trainer_form.save
      SysMailer.trainer_request_email(@trainer_form).deliver_now()
      redirect_to root_path, notice: 'Trainer form was successfully created.'
    else
      render :new
    end
  end

  def update
    @trainer_form = TrainerForm.find(params[:id])

    # Append "Other" reason if provided
    if params[:trainer_form][:reasons]
      reasons = params[:trainer_form][:reasons]
      other_reason = params[:trainer_form][:other_reason]
      reasons << other_reason if other_reason.present?
      @trainer_form.reasons = reasons.join(';')
    end

    if @trainer_form.update(trainer_form_params)
      redirect_to @trainer_form, notice: 'Trainer form was successfully updated.'
    else
      render :edit
    end
  end
  def edit
  end
  # DELETE /trainer_forms/:id
  def destroy
    @trainer_form.destroy
    redirect_to trainer_forms_url, notice: 'Trainer form was successfully deleted.'
  end

  private

  def set_trainer_form
    @trainer_form = TrainerForm.find(params[:id])
  end

  def trainer_form_params
    params.require(:trainer_form).permit(:name, :membership_number, :date_of_birth, :phone, :medical_conditions, :additional_notes)
  end
end
