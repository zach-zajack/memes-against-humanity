class Meme < ApplicationRecord
  belongs_to :round
  belongs_to :player
  delegate :game, to: :round

  validates :source1_id, presence: true

  after_create_commit :broadcast_meme

  def sources
    [
      Source.find_by(id: self.source1_id),
      Source.find_by(id: self.source2_id),
      Source.find_by(id: self.source3_id)
    ].compact
  end

  private

  def broadcast_meme
    BroadcastGameJob.perform_later(game, ["memes", "scoreboard"])
  end
end
