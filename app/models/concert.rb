require 'open-uri'

class Concert < ApplicationRecord

  def update_schedule
    schedule = Nokogiri::HTML(open("https://roskilde.s3.amazonaws.com/rss/artists-2016.xml"))

    list_of_concerts = schedule.css("channel")

  end
end
