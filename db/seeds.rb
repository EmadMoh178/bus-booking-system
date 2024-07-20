# db/seeds.rb
12.times do |i|
  Seat.create(number: i + 1)
end
