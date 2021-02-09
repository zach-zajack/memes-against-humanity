class BroadcastGameJob < ApplicationJob
  queue_as :default

  TYPES = {
    scoreboard: ["scoreboard"],
    message: ["messages"],
    round: ["buttons", "main", "hand", "scoreboard"],
    meme: ["main", "scoreboard"],
    stop: ["buttons", "options", "main", "hand", "scoreboard"]
  }

  def perform(game, type)
    game.players.each do |player|
      PlayerChannel.broadcast_to(player, render_partials(game, player, type))
    end
  end

  private

  def render_partials(game, player, type)
    data = {partials: {}}
    TYPES[type].each do |partial|
      data[:partials][partial] = ApplicationController.render(
        partial: "games/#{partial}",
        locals: { game: game, current_player: player }
      )
    end
    return broadcast
    return data
  end
end
