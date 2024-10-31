class UpdateGuestAgreementNames < ActiveRecord::Migration[5.2]
  def change
    rename_column :guest_agreements, :gp, :is_guest_pass
    rename_column :guest_agreements, :pd, :has_paid
    rename_column :guest_agreements, :t, :has_toured
    add_column :guest_agreements, :zip_code, :integer
  end
end
