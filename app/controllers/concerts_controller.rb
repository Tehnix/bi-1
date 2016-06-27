class ConcertsController < ApplicationController
  before_action :set_concert, only: [:attend,
                                     :like, :unlike]

  before_action :set_interest, only: [:show,
                                      :unattend,
                                      :look_for_individual,
                                      :look_for_group]

  before_action :validate_interest, only: [:like, :unlike]

  def index
    @concerts = Concert.order(:start_time).all

    @concerts.each do |concert|
      set_interest(concert)
      add_friend_and_attendees_to(concert)
    end
  end

  def show
    add_friend_and_attendees_to(@concert)
  end

  def attend
    @interest = @current_user.interests
                             .find_or_create_by(concert_id: @concert.id,
                                                user_id: @current_user.id)

    add_friend_and_attendees_to(@concert)

    render 'show'
  end

  def unattend
    unless @interest.nil?
      @interest.destroy
      @interest = nil
      add_friend_and_attendees_to(@concert)

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

      add_friend_and_attendees_to(@concert)

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

      add_friend_and_attendees_to(@concert)

      render 'show'
    else
      head(:bad_request)
    end
  end

  def like
    @user = @liked_interest.user
    @mutual_concerts = (@user.concerts & @current_user.concerts).length

    if request.post?
      like = Like.new(owner_id: @current_user.id,
                      interest_id: @liked_interest.id)
      like.save
    else
      @liked_interest.likes.find_by(owner_id: @current_user).destroy
    end

    @you_like = !like.nil?
    @likes_you = !(@user.likes & @my_interest.likes).empty?

    render 'like'
  end

  private

  # @concert is available. Luck?
  def validate_interest
    liked_user = User.find_by(profile_id: params[:profile_id])

    interests = Interest.where(concert_id: @concert.id)
                        .where(user_id: [@current_user.id, liked_user.id])

    @liked_interest = interests.find_by(user_id: liked_user.id)
    @my_interest = interests.find_by(user_id: @current_user.id)

    # Return if neither of the two have shown interest in a concert
    return head(:bad_request) if @liked_interest.nil? || @my_interest.nil?
  end

  def set_interest(concert = nil)
    if concert.nil?
      set_concert
    else
      @concert = concert
    end

    @interest = @current_user.interests.find_by(concert_id: @concert.id)
  end

  def set_concert
    @concert = Concert.find(params[:id])
  end

  def add_friend_and_attendees_to(concert)
    interests = concert.interests

    concert.num_attendees = interests.count
    concert.num_friend_attendees = 0

    user_friends = @current_user.friends

    attending = !@interest.nil?

    if attending
      interests -= [@interest]
    else
      @interest = Interest.new
    end

    # Like.joins(:interest).where('interests.concert_id = ?', Concert.second).where('interests.user_id = ?', User.last)
    my_interest_likes = @interest.likes

    @interest.attending = attending

    interests.each do |interest|
      is_friend = user_friends.include? interest.user
      interest.user.mutual_concerts = (interest.user.concerts & @current_user.concerts).length
      interest.user.friend = is_friend
      interest.user.likes_you = !(interest.user.likes & my_interest_likes).empty?
      interest.user.you_like = !@current_user.likes.where(id: interest.likes.ids).empty?

      if is_friend
        concert.num_friend_attendees += 1
      end
    end

    @interests = interests.sort_by { |interest| interest.user.friend ? 0 : 1 }
  end
end
