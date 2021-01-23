class Game < ApplicationRecord
  has_many :players, dependent: :destroy
  has_many :rounds,  dependent: :destroy
  has_many :templates, through: :rounds
  has_many :sources,   through: :players

  before_create :generate_join_code

  def start
    update_attribute(:playing, true)
    reset_score
    advance_round
  end

  def stop
    update_attribute(:playing, false)
  end

  def reset_score
    players.each { |player| player.update_attribute(:score, 0) }
  end

  def advance_round
    players.each(&:hide_played_sources)
    deal_sources
    Round.create(game: self)
  end

  def deal_sources
    players.each do |player|
      (self.source_count - player.visible_sources.count).times do
        Source.create(player: player)
      end
    end
  end

  def master
    players.first
  end

  def generate_join_code
    self.join_code = loop do
      code = Random.new.rand(1000..9999)
      break code unless Game.exists? join_code: code
    end
  end
end
