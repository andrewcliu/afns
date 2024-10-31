class CreateMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :members do |t|
      t.string :name
      t.string :email
      t.string :membership_number
      t.date :date_join
      t.boolean :is_active, default: true 

      t.timestamps
    end
    add_index :members, :membership_number, unique: true
  end
end
