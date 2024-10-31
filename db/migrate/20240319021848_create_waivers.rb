class CreateWaivers < ActiveRecord::Migration[5.2]
  def change
    create_table :waivers do |t|
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.string :email
      t.references :afns_class

      t.timestamps
    end
  end
end
