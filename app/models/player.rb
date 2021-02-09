class Player < ApplicationRecord
  belongs_to :game
  has_many   :sources, dependent: :destroy
  has_many   :memes
  has_many   :messages

  after_create_commit { BroadcastGameJob.perform_later(game, :scoreboard) }
  after_destroy_commit :revalidate_game

  validates_uniqueness_of :name, scope: :game
  validates_length_of :name, minimum: 1, maximum: 20

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
  end

  private

  def revalidate_game
    game.revalidate
    BroadcastGameJob.perform_later(game, :scoreboard)
  end
end
