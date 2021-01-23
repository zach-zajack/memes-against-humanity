class Player < ApplicationRecord
  belongs_to :game
  has_many   :sources, dependent: :destroy
  has_many   :memes
  has_many   :messages

  def master?
    game.master == self
  end
end
