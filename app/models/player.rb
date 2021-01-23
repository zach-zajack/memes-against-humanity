class Player < ApplicationRecord
  belongs_to :game
  has_many   :sources, dependent: :destroy
  has_many   :memes
  has_many   :messages

  def played_sources
    visible_sources.sort_by(&:order).select(&:played?)
  end

  def visible_sources
    sources.reject(&:hidden)
  end

  def hide_played_sources
    played_sources.each(&:hide)
  end

  def master?
    game.master == self
  end
end
