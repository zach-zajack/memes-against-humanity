class GameChannel < ApplicationCable::Channel
  def subscribed
    @game = current_player.game
    stream_for(@game)
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def play_sources(data)
    Meme.create!(
      round_id: @game.round.id,
      player_id: current_player.id,
      source1_id: data["source_ids"][0],
      source2_id: data["source_ids"][1],
      source3_id: data["source_ids"][2]
    )
  end

  def select_meme(data)
  end

  def message(data)
  end
end
