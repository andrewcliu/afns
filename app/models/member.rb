# app/models/member.rb
class Member < ApplicationRecord
  after_create :generate_wallet_link

  attr_accessor :add_to_wallet_link

  private

  def generate_wallet_link
    wallet_service = GoogleWalletService.new
    issuer_id = "3388000000022805894"
    class_suffix = "Member"
    object_suffix = self.id.to_s

    self.add_to_wallet_link = wallet_service.create_jwt_new_objects(issuer_id, class_suffix, object_suffix)
  end
end
