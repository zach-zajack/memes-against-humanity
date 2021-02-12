class BroadcastMessageJob < ApplicationJob
  queue_as :default

  def perform(game, message)
    broadcast_message(game, message)
  end

  private

  def broadcast_message(game, message)
    msg = ApplicationController.render(
      partial: "messages/message",
      locals: { message: message }
    )
    game.players.each do |player|
      PlayerChannel.broadcast_to(player, message: msg)
    end
  end
end
