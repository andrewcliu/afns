class RemoveLockerRoomFromLockers < ActiveRecord::Migration[5.2]
  def change
    remove_column :lockers, :locker_room, :string
  end
end
