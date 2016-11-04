require 'net/http'
require 'json'
require 'geoip'

module Glowy
  class CLI
    def call
      puts "lat: #{get_lat} long: #{get_long}"
      puts "sunrise: #{get_sunrise} sunrise: #{get_sunset}"
    end

    private

    def get_sunset
      DateTime.strptime(get_sunset_time["sunset"]).to_time.localtime.strftime("%I:%M:%S %p")
    end

    def get_sunrise
      DateTime.strptime(get_sunset_time["sunrise"]).to_time.localtime.strftime("%I:%M:%S %p")
    end

    def get_sunset_time
      return @sunset_time if @sunset_time
      url = "http://api.sunrise-sunset.org/json?lat=#{get_lat}&lng=#{get_long}&formatted=0"
      uri = URI(url)
      response = Net::HTTP.get(uri)
      @sunset_time = JSON.parse(response)["results"]
      @sunset_time
    end


    def get_location_info
      return @location_info if @location_info
      url = 'http://ip-api.com/json'
      uri = URI(url)
      response = Net::HTTP.get(uri)
      @location_info = JSON.parse(response)
    end


    def get_ip
      get_location_info["query"]
    end

    def get_lat
      get_location_info["lat"]
    end

    def get_long
      get_location_info["lon"]
    end

    def get_timezone
      get_location_info["timezone"]
    end

  end
end
