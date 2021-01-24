class GameChannel < ApplicationCable::Channel
  def subscribed
    return if params[:join_code].nil?
    @game = Game.find_by(join_code: params[:join_code])
    stream_for(@game)
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def play_sources(data)
    Meme.create!(
      round_id: @game.round.id,
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
