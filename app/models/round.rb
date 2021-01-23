class Round < ApplicationRecord
  belongs_to :game
  has_one    :template, dependent: :destroy
  has_many   :memes,    dependent: :destroy
  delegate   :players, to: :game

  before_create :pick_czar

  def czar
    Player.find(czar_id)
  end

  private

  def pick_czar
    self.czar_id = players[game.rounds.count % players.count].id
  end
end
