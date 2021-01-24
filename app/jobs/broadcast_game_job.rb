class BroadcastGameJob < ApplicationJob
  queue_as :default

  def perform(game, partials)
    @game = game
    GameChannel.broadcast_to(@game, render_partials(partials))
  end

  private

  def render_partials(partials)
    broadcast = {}
    partials.each do |partial|
      broadcast[partial] = ApplicationController.renderer.render(
        partial: "games/#{partial}",
        locals: { game: @game }
      )
    end
    return broadcast
  end
end
