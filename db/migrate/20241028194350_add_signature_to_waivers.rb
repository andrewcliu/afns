class AddSignatureToWaivers < ActiveRecord::Migration[5.2]
  def change
    add_column :waivers, :signature, :string
  end
end
