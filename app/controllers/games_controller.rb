class GamesController < ApplicationController
  before_action :game_initialize

  def start
    @game.start if @game.update(game_params.merge(playing: true))
    render :show
  end

  def show
    render :new_player if current_player.nil?
  end

  private

  def game_params
    params.permit(:max_score, :public, :join_while_playing)
  end

  def game_initialize
    @game = Game.find_by(join_code: params[:join_code]) or record_not_found
    return if current_player&.game == @game
    current_player&.destroy
    cookies.delete(:player_id)
    if @game&.persisted?
      render :new_player
    else
      redirect_to root_url
    end
  end
end
