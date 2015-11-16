class AddTwoFactorToUser < ActiveRecord::Migration
  def change
    add_column :users, :phone_number, :string
    add_column :users, :pin, :string
    add_column :users, :two_factor, :boolean
  end
end
