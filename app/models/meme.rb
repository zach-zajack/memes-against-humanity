class Meme < ApplicationRecord
  belongs_to :round
  belongs_to :player
  delegate :game,     to: :round
  delegate :template, to: :round

  validate :source_count_matches_template

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

  private

  def broadcast_meme
    BroadcastGameJob.perform_later(game, "memes", "scoreboard")
  end

  def source_count_matches_template
    if source_ids.count < template.slots
      errors.add(:base, "not enough sources")
    elsif source_ids.count > template.slots
      errors.add(:base, "too many sources")
    end
  end
end
