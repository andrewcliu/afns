class CreateLockers < ActiveRecord::Migration[5.2]
  def change
    create_table :lockers do |t|
      t.string :locker_number
      t.string :first_name
      t.string :key_tag_number
      t.string :receipt_number
      t.string :locker_room
      t.date :expiration_date
      t.string :staff_name

      t.timestamps
    end
  end
end
