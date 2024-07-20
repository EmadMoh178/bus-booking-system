# app/models/concerns/city_mapping.rb
module CityMapping
  CITIES = {
    "Cairo" => 1,
    "Giza" => 2,
    "AlFayyum" => 3,
    "AlMinya" => 4,
    "Asyut" => 5
  }.freeze

  def self.city_to_number(city_name)
    CITIES[city_name]
  end

  def self.valid_city?(city_name)
    CITIES.key?(city_name)
  end
end
