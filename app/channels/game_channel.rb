class GameChannel < ApplicationCable::Channel
  def subscribed
    return if params[:join_code].nil?
    @game = Game.find_by(join_code: params[:join_code])
    stream_for(@game)
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def play_source
  end

  def select_meme
  end

  def message
  end
end
