class CreateGuestAgreements < ActiveRecord::Migration[5.2]
  def change
    create_table :guest_agreements do |t|
      t.string :name
      t.string :phone
      t.string :email
      t.string :address
      t.string :city
      t.string :state
      t.string :staff
      t.boolean :gp
      t.boolean :pd
      t.boolean :t

      t.timestamps
    end
  end
end
