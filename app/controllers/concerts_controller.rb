class ConcertsController < ApplicationController
  before_action :set_concert, only: [:show,
                                     :attend, :unattend,
                                     :like, :unlike]

  before_action :set_interest, only: [:look_for_individual,
                                      :unlook_for_individual,
                                      :look_for_group,
                                      :unlook_for_group]

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
    attendees = @concert.attendees

    unless attendees.include? @current_user
      attendees << @current_user
      @concert.save
    end

    render_concert
  end

  def unattend
    interest = @concert.interests.find_by(user_id: @current_user.id)
    unless interest.nil?
      interest.destroy
    end

    render_concert
  end

  # +1
  def look_for_individual
    unless @interest.nil?
      @interest.individual = true
      @interest.save
    end

    render_concert
  end

  def unlook_for_individual
    unless @interest.nil?
      @interest.individual = false
      @interest.save
    end

    render_concert
  end

  # +8
  def look_for_group
    unless @interest.nil?
      @interest.group = true
      @interest.save
    end

    render_concert
  end

  def unlook_for_group
    unless @interest.nil?
      @interest.group = false
      @interest.save
    end

    render_concert
  end

  def like
    like = Like.new(stranger_id: @current_user.id)
    like.interests << @liked_interest
    like.save
  end

  def unlike
    @liked_interest.like.destroy
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
    return head(:bad_request) if @liked_interest.nil? || interest.nil?
  end

  def set_interest
    set_concert
    @interest = @current_user.interests.find_by(concert_id: @concert.id)
  end

  def set_concert
    @concert = Concert.find(params[:id])
  end

  def render_concert
    @interests = @concert.interests

    add_friend_and_attendees(@concert)

    render 'show'
  end

  def add_friend_and_attendees(concert)
    interests = concert.interests

    concert.num_attendees = interests.count
    concert.num_friend_attendees = 0

    user_friends = @current_user.friends
    user_likes = @current_user.likes
    interests.each do |interest|
      is_friend = user_friends.include? interest.user
      interest.user.friend = is_friend
      interest.user.likes_you = user_likes.include? interest.like

      if is_friend
        concert.num_friend_attendees += 1
      end
    end

    @interests = interests.sort_by { |interest| interest.user.friend ? 0 : 1 }
  end
end
