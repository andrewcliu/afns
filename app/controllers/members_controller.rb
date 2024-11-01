class MembersController < ApplicationController
  
  before_action :set_member, only: [:show, :edit, :update]
  before_action :require_login
  before_action :require_admin, only: [:destroy, :update]
  def new
    @member = Member.new
  end

  def create
    @member = Member.new(member_params)
    @member.skip_wallet_initialization = true
    if @member.save
      redirect_to members_path, notice: 'Member was successfully created.'
    else
      render :new
    end
  end

  def show
    require_dependency 'google_wallet_service'
    init_google(@member, true)
  end

  def edit
  end

  def update
    if @member.update(member_params)
      redirect_to @member, notice: 'Member was successfully updated.'
    else
      render :edit
    end
  end

  private
  def init_google(member, bool)
    wallet_service = GoogleWalletService.new(member, bool)
    issuer_id = "3388000000022805894"
    class_suffix = "Member"
    object_suffix = @member.id.to_s

    # Generate Google Wallet link
    @add_to_wallet_link = wallet_service.create_jwt_new_objects(issuer_id, class_suffix, object_suffix)
  end
  def member_params
    params.require(:member).permit(:name, :email, :membership_number, :date_join, :is_active)
  end

  # Sets the member for show, edit, and update actions
  def set_member
    @member = Member.find_by(id: params[:id])
    unless @member
      Rails.logger.error "Member with id #{params[:id]} not found."
      render json: { error: 'Member not found' }, status: :not_found
    end
  end
end
