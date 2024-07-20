# db/seeds.rb

# Clear existing data
City.destroy_all
Trip.destroy_all
Bus.destroy_all
Seat.destroy_all

cities = City.create([
                       { name: 'Cairo' },
                       { name: 'Giza' },
                       { name: 'AlFayyum' },
                       { name: 'AlMinya' },
                       { name: 'Asyut' }
                     ])

# Create trips for all possible combinations
cities.each_with_index do |start_city, i|
  cities[i+1..-1].each do |end_city|
    trip = Trip.create(start_city: start_city, end_city: end_city)
    bus = Bus.create(trip: trip)

    # Create 12 seats for each bus
    (1..12).each do |seat_number|
      Seat.create(bus: bus, seat_number: seat_number)
    end
  end
end