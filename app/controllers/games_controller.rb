class GamesController < ApplicationController
  def show
    @game = Game.find_by(join_code: params[:join_code]) or record_not_found
  end
end
