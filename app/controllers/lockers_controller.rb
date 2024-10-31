# app/controllers/lockers_controller.rb
class LockersController < ApplicationController
  before_action :set_locker, only: [:show, :edit_men, :edit_women, :update, :destroy]

  # Separate forms for creating men’s and women’s lockers
  def new_men
    @locker = Locker.new(gender: 'male')
    render :new
  end

  def new_women
    @locker = Locker.new(gender: 'female')
    render :new
  end

  # Display lockers by gender in tabs on the index page
  def index
    @male_lockers = Locker.where(gender: 'male')
    @female_lockers = Locker.where(gender: 'female')
  end

  def show
  end

  def new
    @locker = Locker.new
  end

  # Create action with gender pre-set based on the form used
  def create
    # Assign gender based on which form was used
    if params[:gender] == 'male'
      @locker = Locker.new(locker_params.merge(gender: 'male'))
    elsif params[:gender] == 'female'
      @locker = Locker.new(locker_params.merge(gender: 'female'))
    else

      @locker = Locker.new(locker_params) # Fallback if not using specific form
    end

    if @locker.save
      redirect_to @locker, notice: 'Locker was successfully created.'
    else
      Rails.logger.error "Failed to update Locker: #{@locker.errors.full_messages.join(', ')}"
      render :new
    end
  end

  # Edit actions separated by gender
  def edit_men
    if @locker&.gender == 'Male'
      render :edit
    else
      redirect_to lockers_path, alert: "This is not a men's locker."
    end
  end

  def edit_women
    if @locker&.gender == 'Female'
      render :edit
    else
      redirect_to lockers_path, alert: "This is not a women's locker."
    end
  end
  # Update locker and retain gender
  def update
    if @locker.update(locker_params)
      redirect_to @locker, notice: 'Locker was successfully updated.'
    else
      render :edit
    end
  end

  # Destroy locker action
  def destroy
    @locker.destroy
    redirect_to lockers_url, notice: 'Locker was successfully deleted.'
  end

  private

  # Set the locker instance variable
  def set_locker
    @locker = Locker.find_by(id: params[:id])
    redirect_to lockers_path, alert: 'Locker not found.' unless @locker
  end

  # Permit locker parameters
  def locker_params
    params.require(:locker).permit(:locker_number, :first_name, :key_tag_number, :receipt_number, :expiration_date, :staff_name, :gender)
  end
end
