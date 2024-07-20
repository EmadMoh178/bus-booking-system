# db/migrate/20240719203125_create_trips.rb
class CreateTrips < ActiveRecord::Migration[7.1]
  def change
    create_table :trips do |t|
      t.references :start_city, null: false, foreign_key: { to_table: :cities }
      t.references :end_city, null: false, foreign_key: { to_table: :cities }
      t.timestamps
    end
  end
end