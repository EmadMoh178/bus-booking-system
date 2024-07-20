class CreateBookings < ActiveRecord::Migration[7.1]
  def change
    create_table :bookings do |t|
      t.references :seat, null: false, foreign_key: true
      t.integer :start_station
      t.integer :end_station

      t.timestamps
    end
  end
end
