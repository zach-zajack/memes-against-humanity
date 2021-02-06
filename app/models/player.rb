class Player < ApplicationRecord
  belongs_to :game
  has_many   :sources, dependent: :destroy
  has_many   :memes
  has_many   :messages

  after_create_commit :broadcast_player
  after_destroy_commit { game.revalidate }

  def discard_played_sources
    memes.last&.sources&.each { |source| source.discard }
  end

  def active_sources
    sources.reject(&:discarded)
  end

  def master?
    game.master == self
  end

  def czar?
    game.round&.czar == self
  end

  def winner?
    game.round&.winner == self
  end

  def ready?
    game.round&.memes&.include? memes.last
  end

  def playing?
    !ready?
  end

  def can_kick?(player)
    master? && self != player
  end

  def kick
    self.destroy
    broadcast_player
  end

  private

  def broadcast_player
    BroadcastGameJob.perform_later(game, "scoreboard")
  end
end
