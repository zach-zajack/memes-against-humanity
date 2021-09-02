class Round < ApplicationRecord
  acts_as_paranoid

  belongs_to :game
  has_one    :template, dependent: :destroy
  has_many   :memes,    dependent: :destroy
  delegate   :players, to: :game

  before_create :pick_czar
  before_create :generate_template
  before_create :generate_seed
  after_create_commit { BroadcastGameJob.perform_later(game, :round) }

  def czar
    Player.find_by(id: czar_id)
  end

  def winner
    Player.find_by(id: winner_id)
  end

  def memes_shuffled
    memes.shuffle(random: Random.new(self.shuffle_seed))
  end

  private

  def pick_czar
    self.czar_id = game.ordered_players[game.rounds.count % players.count].id
  end

  def generate_template
    self.template = Template.create
  end

  def generate_seed
    self.shuffle_seed = Random.new.rand(0..0x7FFF_FFFF)
  end
end
