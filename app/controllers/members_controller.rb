# app/controllers/members_controller.rb
require_dependency 'google_wallet_service'
class MembersController < ApplicationController
  # include GoogleWalletHelper

  def new
    @member = Member.new
  end

  def create
    @member = Member.new(member_params)
    if @member.save
      redirect_to @member, notice: 'Member was successfully created.'
    else
      render :new
    end
  end

  def show
    @member = Member.find(params[:id])
    wallet_service = GoogleWalletService.new(@member)
    issuer_id = "3388000000022805894"  # Replace with your actual issuer ID
    class_suffix = "Member"   # Define a unique class suffix
    object_suffix = @member.id.to_s # Use member ID as object suffix for uniqueness

    # Get the Google Wallet link
    @add_to_wallet_link = wallet_service.create_jwt_new_objects(issuer_id, class_suffix, object_suffix)
  end

  def edit
    @member = Member.find(params[:id])
  end

  def update
    @member = Member.find(params[:id])
    if @member.update(member_params)
      redirect_to @member, notice: 'Member was successfully updated.'
    else
      render :edit
    end
  end

  private

  def member_params
    params.require(:member).permit(:name, :email, :membership_number, :date_join, :is_active)
  end

def set_member
  @member = Member.find_by(id: params[:id])
  unless @member
    Rails.logger.error "Member with id #{params[:id]} not found."
    render json: { error: 'Member not found' }, status: :not_found
  end
end
end
