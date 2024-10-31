class AddRoomToAfnsClasses < ActiveRecord::Migration[5.2]
  def change
    add_column :afns_classes, :room, :string
  end
end
