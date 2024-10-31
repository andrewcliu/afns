class GuestAgreementsController < ApplicationController
  before_action :set_guest_agreement, only: %i[show destroy]
  def index
    
    @guest_agreements = GuestAgreement.all
  end

  def create
    @guest_agreement = GuestAgreement.new(guest_agreement_params)

    if params[:signature_data].present?
      data_url = params[:signature_data]
      signature_data = Base64.decode64(data_url.split(",")[1])

      @guest_agreement.signature.attach(
        io: StringIO.new(signature_data), 
        filename: "signature.png", 
        content_type: "image/png"
      )
    end

    if @guest_agreement.save
      redirect_to @guest_agreement, notice: 'Guest agreement was successfully created.'
    else
      render :new
    end
  end
  def new 
    @guest_agreement = GuestAgreement.new
  end
  def destroy
    # Detach and delete the signature if it exists
    @guest_agreement.signature.purge if @guest_agreement.signature.attached?

    # Delete the guest agreement record
    @guest_agreement.destroy
    redirect_to guest_agreements_url, notice: 'Guest agreement was successfully destroyed.'
  end

  private

  def set_guest_agreement
    @guest_agreement = GuestAgreement.find(params[:id])
  end

  def guest_agreement_params
    params.require(:guest_agreement).permit(:name, :phone, :email, :address, :city, :state, :zip_code, :is_guest_pass, :has_paid, :has_toured, :staff, :signature_data)
  end

end
