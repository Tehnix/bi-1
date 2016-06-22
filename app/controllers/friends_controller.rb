class FriendsController < ApplicationController
  before_action :set_friend, only: [:show, :update, :destroy]

  # GET /friends
  # GET /friends.json
  def index
    @friends = @current_user.friends
  end

  # GET /friends/1
  # GET /friends/1.json
  def show
  end

  # POST /friends
  # POST /friends.json
  def create
    @concert = Concert.new(concert_params)

    if @concert.save
      render :show, status: :created, location: @concert
    else
      render json: @concert.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /friends/1
  # PATCH/PUT /friends/1.json
  def update
    if @concert.update(concert_params)
      render :show, status: :ok, location: @concert
    else
      render json: @concert.errors, status: :unprocessable_entity
    end
  end

  # DELETE /friends/1
  # DELETE /friends/1.json
  def destroy
    @concert.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  def set_concert
    print(params[:id])
    @concert = Concert.find(params[:id])
    print(@concert.inspect)
  end

    # Never trust parameters from the scary internet, only allow the white list through.
    def concert_params
      params.require(:concert).permit(:artist, :time_of_day, :venue)
    end
end
