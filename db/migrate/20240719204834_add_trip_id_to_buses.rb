class AddTripIdToBuses < ActiveRecord::Migration[7.1]
  def change
    add_column :buses, :trip_id, :integer
  end
end
