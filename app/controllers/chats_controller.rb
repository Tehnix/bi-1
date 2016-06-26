class ChatsController < ApplicationController

  def index
    @chats = Chat.joins(:participants)
                 .includes(:messages).order('messages.date DESC')
                                     .where('user_id = ?',
                                            @current_user)
    @chats.each do |chat|
      chat.recent_message = chat.messages.order('date DESC')
                                         .limit(1).first
    end
  end

  def show
    @chat = @current_user.chats.find(params[:id])
  end

  def create
    concert_id = params[:concert_id]
    profile_id = params[:profile_id]

    target_user = User.find_by(profile_id: profile_id)

    target_interest = Interest.find_by(user_id: target_user.id,
                                       concert_id: concert_id)
    current_interest = Interest.find_by(user_id: @current_user.id,
                                        concert_id: concert_id)

    if target_interest.nil? || current_interest.nil?
      head(:bad_request)
    end

    # Only supports +1 chats
    if !(target_interest.likes & @current_user.likes).empty? &&
       !(target_user.likes & current_interest.likes).empty?
      @chat = Chat.where(concert_id: concert_id)
                  .joins(:participants)
                  .merge(User.where(id: @current_user.id))
                  .merge(User.where(id: target_user.id))
                  .first

      if @chat.nil?
        @chat = Chat.create(concert_id: concert_id)
        @chat.participants << target_user
        @chat.participants << @current_user

        render 'show'
      else
        head(:bad_request)
      end
    else
      head(:bad_request)
    end
  end

end
