class Meme < ApplicationRecord
  acts_as_paranoid

  belongs_to :round
  belongs_to :player
  delegate :game,     to: :round
  delegate :template, to: :round

  validate :source_count_matches_template
  validate :player_submitted_once
  validate :player_czarnt
  validate :player_owns_sources

  after_create_commit { BroadcastGameJob.perform_later(game, :meme) }

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
    round.update_attribute(:winner_id, player.id)
    game.advance
  end

  private

  def source_count_matches_template
    if source_ids.count < template.slots
      errors.add(:base, "not enough sources")
    elsif source_ids.count > template.slots
      errors.add(:base, "too many sources")
    end
  end

  def player_submitted_once
    errors.add(:base, "player has already submitted") if player.ready?
  end

  def player_czarnt
    errors.add(:base, "the czar cannot create a meme") if player.czar?
  end

  def player_owns_sources
    if source_ids.any? { |id| player.sources.map(&:id).exclude?(id) }
      errors.add(:base, "player does not own all of the sources submitted")
    end
  end
end
