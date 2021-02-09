class GamesController < ApplicationController
  before_action :game_initialize

  def start
    return unless @game.update(game_params.merge(playing: true))
    @game.start
    render :show
  end

  def stop
    @game.stop
  end

  def show
    render :new_player if current_player.nil?
  end

  private

  def game_params
    params.permit(:max_score, :public, :join_midgame, :source_count)
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
