class RemoveUniqueConstraintFromLockerNumber < ActiveRecord::Migration[5.2]
  def change
    remove_index :lockers, :locker_number if index_exists?(:lockers, :locker_number)
  end
end
