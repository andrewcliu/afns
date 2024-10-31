class AddUniqueIndexToLockerNumberAndGender < ActiveRecord::Migration[5.2]
  def change
    add_index :lockers, [:locker_number, :gender], unique: true
  end
end
