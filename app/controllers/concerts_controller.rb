class ConcertsController < ApplicationController
  before_action :set_concert, only: [:show,
                                     :attend,
                                     :like, :unlike]

  before_action :set_interest, only: [:unattend,
                                      :look_for_individual,
                                      :look_for_group]

  before_action :validate_interest, only: [:like, :unlike]

  def index
    @concerts = Concert.order(:start_time).all

    @concerts.each do |concert|
      add_friend_and_attendees(concert)
    end
  end

  def show
    add_friend_and_attendees(@concert)
  end

  def attend
    @interest = @current_user.interests
                             .find_or_create_by(concert_id: @concert.id,
                                                user_id: @current_user.id)

    add_friend_and_attendees(@concert)

    render 'show'
  end

  def unattend
    unless @interest.nil?
      @interest.destroy

      add_friend_and_attendees(@concert)

      render 'show'
    else
      head(:bad_request)
    end
  end

  # +1
  def look_for_individual
    unless @interest.nil?
      @interest.individual = request.post?
      @interest.save

      add_friend_and_attendees(@concert)

      render 'show'
    else
      head(:bad_request)
    end
  end

  # +8
  def look_for_group
    unless @interest.nil?
      @interest.group = request.post?
      @interest.save

      add_friend_and_attendees(@concert)

      render 'show'
    else
      head(:bad_request)
    end
  end

  def like
    @user = @liked_interest.user
    @mutual_concerts = (@user.concerts & @current_user.concerts).length

    if request.post?
      like = Like.new(stranger_id: @current_user.id)
      like.interests << @liked_interest
      like.save
    else
      @liked_interest.like.destroy
    end

    render 'like'
  end

  private

  # @concert is available. Luck?
  def validate_interest
    liked_user = User.find_by(profile_id: params[:profile_id])

    interests = Interest.where(concert_id: @concert.id)
                        .where(user_id: [@current_user.id, liked_user.id])

    @liked_interest = interests.find_by(user_id: liked_user.id)
    interest = interests.find_by(user_id: @current_user.id)

    # Return if neither of the two have shown interest in a concert
    head(:bad_request) if @liked_interest.nil? || interest.nil?
  end

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
    user_likes = @current_user.likes

    unless @interest.nil?
      interests -= [@interest]
    end

    interests.each do |interest|
      is_friend = user_friends.include? interest.user
      interest.user.mutual_concerts = (interest.user.concerts & @current_user.concerts).length
      interest.user.friend = is_friend
      interest.user.likes_you = user_likes.include? interest.like

      if is_friend
        concert.num_friend_attendees += 1
      end
    end

    @interests = interests.sort_by { |interest| interest.user.friend ? 0 : 1 }
  end
end
