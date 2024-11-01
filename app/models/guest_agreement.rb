class GuestAgreement < ApplicationRecord
	has_one_attached :signature
  validates :name, presence: true
  validates :phone, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email format" }
  validates :address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip_code, presence: true
  validates :signature, presence: true
end
