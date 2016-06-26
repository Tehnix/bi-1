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

end
