class ConcertsController < ApplicationController
  before_action :set_concert, only: [:show, :attend]

  def index
    @concerts = Concert.all

    @concerts.each do |concert|
      add_friend_and_attendees(concert)
    end
  end

  def show
    add_friend_and_attendees(@concert)
  end

  def attend

  end

  private

  def set_concert
    @concert = Concert.find(params[:id])
  end

  def add_friend_and_attendees(concert)
    attendees = concert.attendees

    concert.num_attendees = attendees.count
    concert.friend_attendees =
      attendees.where(profile_id: @current_user.friends
                                               .pluck(:profile_id))
               .pluck_to_hash(:profile_id)
  end
end
