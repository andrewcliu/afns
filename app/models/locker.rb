class Locker < ApplicationRecord
  enum gender: { male: 'Male', female: 'Female' }

  validates :locker_number, presence: true, uniqueness: { scope: :gender, message: "is already taken in this locker room" }
  validates :gender, presence: true, inclusion: { in: genders.keys }


end