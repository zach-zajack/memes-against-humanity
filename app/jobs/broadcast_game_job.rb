class BroadcastGameJob < ApplicationJob
  queue_as :default

  def perform(game, partials)
    game.players.each do |player|
      PlayerChannel.broadcast_to(player, render_partials(game, player, partials))
    end
  end

  private

  def render_partials(game, player, partials)
    broadcast = {}
    partials.each do |partial|
      broadcast[partial] = ApplicationController.render(
        partial: "games/#{partial}",
        locals: { game: game, current_player: player }
      )
    end
    return broadcast
  end
end
