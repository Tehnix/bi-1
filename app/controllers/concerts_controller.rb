class ConcertsController < ApplicationController
  before_action :set_concert, only: [:show, :attend, :show_interest]
  before_action :set_interest, only: [:look_for_individual,
                                      :look_for_group]

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
    attendees = @concert.attendees

    unless attendees.include? @current_user
      attendees << @current_user
      @concert.save
    end
  end

  # +1
  def look_for_individual
    unless @interest.nil?
      @interest.individual = true
      @interest.save
    end
  end

  # +8
  def look_for_group
    unless @interest.nil?
      @interest.group = true
      @interest.save
    end
  end

  # `Like` a person (+1)
  def show_interest
    @user = User.find(params[:profile_id])

    likes = @user.interests.find_by(concert_id: @concert.id).likes
    likes << @current_user
    likes.save
  end

  private

  def set_interest
    set_concert
    @interest = @current_user.interests.find_by(concert_id: @concert.id)
  end

  def set_concert
    @concert = Concert.find(params[:id])
  end

  def add_friend_and_attendees(concert)
    interests = concert.interests

    concert.num_attendees = interests.count
    concert.num_friend_attendees = 0

    user_friends = @current_user.friends
    interests.each do |interest|
      is_friend = user_friends.include? interest.user
      interest.user.friend = is_friend

      if is_friend
        concert.num_friend_attendees += 1
      end
    end

    @interests = interests.sort_by { |interest| interest.user.friend ? 0 : 1 }
  end
end
