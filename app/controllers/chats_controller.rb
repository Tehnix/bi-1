class ChatsController < ApplicationController

  def index
    @chats = User.find_by(id: @current_user.id).chats
    render json: @chats, status: :ok
  end

  def show
    @chat = User.find_by(id: @current_user.id).chats.find(params[:id])

    render :show, status: :ok, location: @chat
  end

end
