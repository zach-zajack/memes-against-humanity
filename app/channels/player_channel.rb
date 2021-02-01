class PlayerChannel < ApplicationCable::Channel
  def subscribed
    @game = current_player.game
    stream_for(current_player)
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
    meme = Meme.find(data["meme_id"])
    meme.select_winner
  end

  def message(data)
    Message.create!(player_id: current_player.id, content: data["content"])
  end
end
