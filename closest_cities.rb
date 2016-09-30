require_relative "haversine"
require "geocoder"
require "pp"

CITIES = [
  "Los Angeles",
  "San Francisco",
  "Boston",
  "New York",
  "Washington",
  "Seattle",
  "Austin",
  "Chicago",
  "San Diego",
  "Denver",
  "London",
  "Toronto",
  "Sydney",
  "Melbourne",
  "Paris",
  "Singapore"
]

def closest_cities
  locations = []

  CITIES.each do |city|
    # uses Geocoder gem to find latitude and longitude
    lat_lng = Geocoder.search(city).first.data["geometry"]["location"]
    locations.push( [ lat_lng["lat"], lat_lng["lng"] ] )
  end

  min_dist = nil
  min_dist_cities = nil

  locations.each_with_index do |loc1, i|
    # micro-optimization so we never check the same pair twice
    ((i + 1)...locations.length).each do |j|
      loc2 = locations[j]

      # This uses the haversine formula, required from "haversine.rb"
      dist = distance(loc1, loc2)

      # Set the new minimum distance if this distance is less
      if !min_dist || dist < min_dist
        min_dist = dist
        min_dist_cities = [CITIES[i], CITIES[j]]
      end
    end
  end

  min_dist_cities
end

if $PROGRAM_NAME == __FILE__
  puts closest_cities
end
