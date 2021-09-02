class Game < ApplicationRecord
  acts_as_paranoid

  has_many :players, dependent: :destroy
  has_many :rounds,  dependent: :destroy
  has_many :templates, through: :rounds
  has_many :sources,   through: :players
  has_many :memes,     through: :players
  has_many :messages

  before_create :generate_join_code

  validate :player_minimum_reached

  def start
    PlayerChannel.broadcast_to(master, partials: {options: ""})
    reset_score
    advance_round
  end

  def stop
    update_attribute(:playing, false)
    BroadcastGameJob.perform_later(self, :stop)
    sources.each(&:destroy)
    rounds.each(&:destroy)
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
    ordered_rounds.last
  end

  def prev_round
    ordered_rounds.second_to_last
  end

  def ordered_rounds
    rounds.order("created_at ASC")
  end

  def master
    ordered_players.first
  end

  def ordered_players
    players.order("created_at ASC")
  end

  def active_players
    players.reject(&:inactive?)
  end

  def revalidate
    players.reload
    stop unless self.valid?
    self.destroy if players.count < 1
  end

  private

  def generate_join_code
    self.join_code = loop do
      code = Random.new.rand(1000..9999)
      break code unless Game.exists?(join_code: code)
    end
  end

  def player_minimum_reached
    return unless self.playing && self.players.count < 3
    errors.add(:base, "not enough players")
  end
end
