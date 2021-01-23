class Meme < ApplicationRecord
  belongs_to :round

  validates_presence_of :source1_id

  def author
    self.source1_id.player
  end

  def sources
    [
      Source.find_by(id: self.source1_id),
      Source.find_by(id: self.source2_id),
      Source.find_by(id: self.source3_id)
    ].compact
  end
end
