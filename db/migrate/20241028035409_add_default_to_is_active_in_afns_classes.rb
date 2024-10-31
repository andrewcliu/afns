class AddDefaultToIsActiveInAfnsClasses < ActiveRecord::Migration[5.2]
  def change
    change_column_default :afns_classes, :is_active, from: nil, to: true
  end
end
