# app/models/member.rb
class Member < ApplicationRecord
  attr_accessor :skip_wallet_initialization

  after_create :initialize_wallet_service, unless: -> { skip_wallet_initialization }
  validates :name, presence: true
  validates :email, presence: true
  validates :membership_number, presence: true
  validates :date_join, presence: true
  private

  def initialize_wallet_service
    GoogleWalletService.new(self)
  end
end
