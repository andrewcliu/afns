class CreateAfnsClasses < ActiveRecord::Migration[5.2]
  def change
    create_table :afns_classes do |t|
      t.string :name
      t.string :instructor
      t.boolean :is_active

      t.timestamps
    end
  end
end
