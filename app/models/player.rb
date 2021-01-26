class Player < ApplicationRecord
  belongs_to :game
  has_many   :sources, dependent: :destroy
  has_many   :memes
  has_many   :messages

  after_create_commit :broadcast_player

  def master?
    game.master == self
  end

  private

  def broadcast_player
    BroadcastGameJob.perform_later(game, "scoreboard")
  end
end
