class Waiver < ApplicationRecord
	belongs_to :afns_class
	has_one_attached :signature
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :phone, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email format" }
  validates :afns_class_id, presence: true
  validates :signature, presence: true
	def name 
		"#{first_name} #{last_name}"
	end

end
