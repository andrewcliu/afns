class Waiver < ApplicationRecord
	belongs_to :afns_class
	has_one_attached :signature
	def name 
		"#{first_name} #{last_name}"
	end

end
