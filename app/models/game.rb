class Game < ApplicationRecord
  has_many :players, dependent: :destroy
  has_many :rounds,  dependent: :destroy
  has_many :templates, through: :rounds
  has_many :sources,   through: :players
  has_many :memes,     through: :players
  has_many :messages,  through: :players

  before_create :generate_join_code

  validate :player_minimum_reached

  def start
    PlayerChannel.broadcast_to(master, options: "")
    reset_score
    advance_round
  end

  def stop
    update_attribute(:playing, false)
    BroadcastGameJob.perform_later(self, "buttons", "options", "main", "hand", "scoreboard")
  end

  def reset_score
    players.each { |player| player.update_attribute(:score, 0) }
  end

  def advance
    anyone_win? ? stop : advance_round
  end

  def advance_round
    active_players.each(&:discard_played_sources)
    deal_sources
    Round.create(game: self)
  end

  def deal_sources
    players.each do |player|
      (self.source_count - player.active_sources.count).times do
        Source.create(player: player)
      end
    end
  end

  def anyone_win?
    players.any? { |player| player.score >= self.max_score }
  end

  def round
    rounds.last
  end

  def master
    players.first
  end

  def active_players
    players.excluding(round&.czar)
  end

  def revalidate
    players.reload
    stop unless self.valid?
  end

  private

  def generate_join_code
    self.join_code = loop do
      code = Random.new.rand(1000..9999)
      break code unless Game.exists?(join_code: code)
    end
  end

  def player_minimum_reached
    if self.playing && self.players.count < 3
      errors.add(:base, "not enough players")
    end
  end
end
