class AddGenderToLockers < ActiveRecord::Migration[5.2]
  def change
    add_column :lockers, :gender, :string
  end
end
