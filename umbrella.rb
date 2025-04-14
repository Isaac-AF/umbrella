# Write your solution below!
require "http"
require "json"
require "dotenv/load"

google_api_key = ENV.fetch("GMAPS_KEY")
pirateweather_api_key = ENV.fetch("PIRATE_KEY")

print "Where are you located?\n"

location = gets.chomp.gsub(" ","%20")

print "Checking the weather at #{location}...\n"

maps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{location}&key=#{google_api_key}"

response = HTTP.get(maps_url)
parsed_response = JSON.parse(response.to_s)

latitude = parsed_response.fetch("results").at(0).fetch("geometry").fetch("location").fetch("lat")
longitude = parsed_response.fetch("results").at(0).fetch("geometry").fetch("location").fetch("lng")

print "The coordinates of your location are #{latitude}, #{longitude}.\n"

#print "It is currently #{temperature}"
