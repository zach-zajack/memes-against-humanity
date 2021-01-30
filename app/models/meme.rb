class Meme < ApplicationRecord
  belongs_to :round
  belongs_to :player
  delegate :game,     to: :round
  delegate :template, to: :round

  validate :source_count_matches_template
  validate :player_submitted_once

  after_create_commit :broadcast_meme

  def sources
    [
      Source.find_by(id: self.source1_id),
      Source.find_by(id: self.source2_id),
      Source.find_by(id: self.source3_id)
    ].compact
  end

  def source_ids
    [self.source1_id, self.source2_id, self.source3_id].compact
  end

  def select_winner
    player.increment!(:score)
    game.advance
  end

  private

  def broadcast_meme
    BroadcastGameJob.perform_later(game, "template", "memes", "scoreboard")
  end

  def source_count_matches_template
    if source_ids.count < template.slots
      errors.add(:base, "not enough sources")
    elsif source_ids.count > template.slots
      errors.add(:base, "too many sources")
    end
  end

  def player_submitted_once
    if player.ready?
      errors.add(:base, "player has already submitted")
    end
  end
end
