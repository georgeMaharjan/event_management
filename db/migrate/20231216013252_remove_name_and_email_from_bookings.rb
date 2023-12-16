class RemoveNameAndEmailFromBookings < ActiveRecord::Migration[7.1]
  def change
    remove_column :bookings, :name, :string
    remove_column :bookings, :email, :string
  end
end
