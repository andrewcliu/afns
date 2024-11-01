class AddAdminAndRoleToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :admin, :boolean
    add_column :users, :role, :integer
  end
end
