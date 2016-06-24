require 'open-uri'

class Concert < ApplicationRecord
  attr_accessor :num_attendees,
                :num_friend_attendees

  has_many :interests
  has_many :attendees, through: :interests, class_name: 'User', source: :user, foreign_key: 'attendant_id'

  class << self

    def update_schedule
      schedule = JSON.load(open("http://www.roskilde-festival.dk/api/artists"))

      schedule.keep_if { |artist| artist['year'] == 2016 }

      schedule.each do |artist|
        start_time = DateTime.strptime(artist['gigs'][0]['dateTime'],
                                       '%Y-%m-%dT%H:%M:%S.%L%Z')
        end_time = DateTime.strptime(artist['gigs'][0]['endDateTime'],
                                     '%Y-%m-%dT%H:%M:%S.%L%Z')
        venue = artist['gigs'][0]['stage']['name']
        artist_name = artist['displayName']

        @concert = Concert.create_with(start_time: start_time,
                                       end_time: end_time,
                                       venue: venue)
                          .find_or_create_by(artist: artist_name)
        @concert.with_lock do
          # If any of the attributes have changed simply force an update
          if @concert.start_time != start_time or
             @concert.end_time != end_time
            @concert.update(start_time: start_time,
                            end_time: end_time,
                            venue: venue)
          end
        end
      end

    end

  end

end
