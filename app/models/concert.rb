require 'open-uri'

class Concert < ApplicationRecord
  attr_accessor :num_attendees,
                :num_friend_attendees

  has_many :interests
  has_many :attendees, through: :interests, class_name: 'User', source: :user, foreign_key: 'attendant_id'

  has_many :images

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

        placeholder = {'url' => '',
                       'width' => '',
                       'height' => ''}

        image = artist['image'] || placeholder
        thumb = artist['thumb'] || placeholder

        @concert = Concert.create_with(start_time: start_time,
                                       end_time: end_time,
                                       venue: venue)
                          .find_or_create_by(artist: artist_name)
        Image.create_with(url: image['url'],
                          height: image['height'],
                          width: image['width'])
             .find_or_create_by(concert_id: @concert.id, image_type: 'image')
        Image.create_with(url: thumb['url'],
                          height: thumb['height'],
                          width: thumb['width'])
             .find_or_create_by(concert_id: @concert.id, image_type: 'thumb')

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
