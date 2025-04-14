# Write your solution below!
require "http"
require "json"
require "dotenv/load"

google_api_key = ENV.fetch("GMAPS_KEY")
pirateweather_api_key = ENV.fetch("PIRATE_KEY")

print "Where are you located?\n"

location = gets.chomp.gsub(" ","%20")

print "Checking the weather at #{location}...\n\n"

maps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{location}&key=#{google_api_key}"

response = HTTP.get(maps_url)
parsed_response = JSON.parse(response.to_s)

latitude = parsed_response.fetch("results").at(0).fetch("geometry").fetch("location").fetch("lat")
longitude = parsed_response.fetch("results").at(0).fetch("geometry").fetch("location").fetch("lng")

print "The coordinates of your location are #{latitude}, #{longitude}.\n"

pirate_url = "https://api.pirateweather.net/forecast/#{pirateweather_api_key}/#{latitude},#{longitude}"

response = HTTP.get(pirate_url)
parsed_response = JSON.parse(response.to_s)

current_temp = parsed_response.fetch("currently").fetch("temperature")

print "It is currently #{current_temp}°F.\n"

next_hour_summary = parsed_response.fetch("minutely").fetch("summary")

print "Next hour: #{next_hour_summary}.\n\n"

hourly_precipitation = []

12.times do |hour|
  hourly_precipitation.push(parsed_response.fetch("hourly").fetch("data").at(hour).fetch("precipProbability"))
end

print "Precipitation probability vs. Hours from now"

steps = 0
max_precip = (hourly_precipitation.max * 100).round(-1)
print "\n"

while steps <= max_precip/5.0
  if max_precip - steps * 5 == 5 || max_precip - steps * 5 == 0
    print " "
    print max_precip - steps * 5
  else
    print max_precip - steps * 5
  end
  print "|"

  hourly_precipitation.each do |hour|
    if hour * 100 > max_precip - ((steps + 1) * 5)
      print "*  "
    else
      print "   "
    end
  end
  print "\n"
  steps = steps + 1
end

print "   ----------------------------------\n"
print "   1  2  3  4  5  6  7  8  9 10 11 12\n"

if max_precip > 10
  print "You might want to carry an umbrella!\n"
else
  print "No need to bring an umbrella today.\n"
end
#print hourly_precipitation
