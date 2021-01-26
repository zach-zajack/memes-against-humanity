class GamesController < ApplicationController
  before_action :game_initialize

  def start
    @game.start if @game.update(game_params.merge(playing: true))
  end

  def show
  end

  private

  def game_params
    params.permit(:max_score, :public, :join_while_playing)
  end

  def game_initialize
    @game = Game.find_by(join_code: params[:join_code]) or record_not_found
  end
end
