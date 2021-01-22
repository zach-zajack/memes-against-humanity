class PlayersController < ApplicationController
  def new
    @player = Player.new
  end

  def create
    @game ||= Game.new
    @player = Player.new(player_params.merge(game: @game))
    if @player.save
      cookies.signed[:player_id] = @player.id
      @game.save
      redirect_to game_path(@game.join_code)
    else
      render :new
    end
  end

  private

  def player_params
    params.require(:player).permit(:name)
  end
end
