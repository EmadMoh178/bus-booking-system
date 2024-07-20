# db/migrate/20240719203142_create_bookings.rb
class CreateBookings < ActiveRecord::Migration[7.1]
  def change
    create_table :bookings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :seat, null: false, foreign_key: true
      t.references :start_city, null: false, foreign_key: { to_table: :cities }
      t.references :end_city, null: false, foreign_key: { to_table: :cities }
      t.timestamps
    end
  end
end