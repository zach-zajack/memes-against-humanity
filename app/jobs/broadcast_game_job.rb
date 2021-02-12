class BroadcastGameJob < ApplicationJob
  queue_as :default

  TYPES = {
    scoreboard: ["scoreboard"],
    round: ["buttons", "main", "hand", "scoreboard"],
    meme: ["main", "scoreboard"],
    leave: ["options", "scoreboard"],
    stop: ["buttons", "options", "main", "hand", "scoreboard"]
  }

  def perform(game, type)
    @game = game
    @type = type
    @game.players.each do |player|
      PlayerChannel.broadcast_to(player, render_partial(player))
    end
  end

  private

  def render_partial(player)
    data = {partials: {}}
    TYPES[type].each do |partial|
      data[:partials][partial] = ApplicationController.render(
        partial: "games/#{partial}",
        locals: { game: @game, current_player: player }
      )
    end
    data[:winner] = last_winner
    return data
  end

  def last_winner
    case @type
    when :round then winner_data(@game.prev_round&.winner)
    when :stop  then winner_data(@game.round&.winner)
    end
  end

  def winner_data(winner)
    {id: winner.id, meme_id: winner.memes.last.id} unless winner.nil?
  end
end
