class TrainerForm < ApplicationRecord
  validates :name, presence: true
  validates :membership_number, presence: true
  validates :date_of_birth, presence: true
  validates :reasons, presence: true
  validates :phone, presence: true
  
end
