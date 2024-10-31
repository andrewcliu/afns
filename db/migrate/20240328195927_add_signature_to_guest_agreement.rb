class AddSignatureToGuestAgreement < ActiveRecord::Migration[5.2]
  def change
        add_column :guest_agreements, :signature, :string
  end
end
