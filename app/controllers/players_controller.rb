class PlayersController < ApplicationController
  def new
    @player = Player.new
  end

  def create
    @game ||= Game.new
    @player = Player.new(player_params.merge(game: @game))

    respond_to do |format|
      if @player.save
        cookies.signed[:player_id] = @player.id
        @game.save
        format.html { redirect_to game_path(@game.join_code) }
        format.json do
          render :show, status: :created, location: game_path(@game.join_code)
        end
      else
        format.html { render :new }
        format.json do
          render json: @player.errors, status: :unprocessable_entity
        end
      end
    end
  end

  private

  def player_params
    params.require(:player).permit(:name)
  end
end
