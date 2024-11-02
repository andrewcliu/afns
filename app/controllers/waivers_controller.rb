class WaiversController < ApplicationController
  before_action :set_waiver, only: [:show, :edit, :update, :destroy]
  # before_action :require_login, except: [:new, :create]
  before_action :require_admin, only: [:destroy, :update]
  def index
    @waivers = Waiver.all
  end

  def show
  end

  def new
    @waiver = Waiver.new
    @active_classes = AfnsClass.where(is_active: true)
  end


  def create
    @waiver = Waiver.new(waiver_params)
    
    if params[:signature_data].present?
      # If the signature is provided as a Base64 data URL, decode and save it
      data_url = params[:signature_data]
      signature_data = Base64.decode64(data_url.split(",")[1]) # Extracts binary data

      # Store the decoded image file (e.g., using ActiveStorage)
      @waiver.signature.attach(io: StringIO.new(signature_data), filename: "signature.png", content_type: "image/png")
    end

    if @waiver.save

      redirect_to root_path, notice: 'Waiver was successfully created.'
    else
      render :new
    end
  end

  def edit
    @active_classes = AfnsClass.where(is_active: true)
  end

  def update
    if @waiver.update(waiver_params)
      if params[:signature_data].present?
        data_url = params[:signature_data]
        signature_data = Base64.decode64(data_url.split(",")[1])
        @waiver.signature.purge if @waiver.signature.attached? # Delete existing signature
        @waiver.signature.attach(io: StringIO.new(signature_data), filename: "signature.png", content_type: "image/png")
      end
      redirect_to @waiver, notice: 'Waiver was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @waiver.signature.purge if @waiver.signature.attached? # Delete signature attachment if present
    @waiver.destroy
    redirect_to waivers_url, notice: 'Waiver was successfully destroyed.'
  end

  private

  def set_waiver
    @waiver = Waiver.find(params[:id])
  end

  def waiver_params
    params.require(:waiver).permit(:first_name, :last_name, :phone, :email, :afns_class_id, :signature)
  end
end
