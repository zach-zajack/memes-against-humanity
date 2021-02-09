class PlayersController < ApplicationController
  before_action :check_games

  def new
    @player = Player.new
  end

  def create
    # TODO: handle nil games for players browsing public games
    @player = Player.new(name: params[:name], game: @game)
    if @player.save
      cookies.signed[:player_id] = @player.id
      @game.save
      redirect_to game_path(@game.join_code)
    else
      render :new
    end
  end

  def create_game
    @game = Game.new
    create
  end

  def kick
    return unless current_player.master?
    Player.find(params[:id]).destroy
  end

  def destroy
    player = Player.find(params[:id])
    player.destroy if current_player == player
  end

  private

  def check_games
    @game = Game.find_by(join_code: params[:join_code])
  end
end
