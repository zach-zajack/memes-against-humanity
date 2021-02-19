class Source < ApplicationRecord
  acts_as_paranoid

  belongs_to :player
  delegate :game, to: :player

  before_create :generate_source_path

  def discard
    update_attribute(:discarded, true)
  end

  private

  ROOT = "https://www.shitpostbot.com/img/sourceimages/"
  DATA = JSON.parse(S3_BUCKET.object("sources.json").get.body.read)

  def generate_source_path
    game.reload
    self.path = loop do
      index = Random.new.rand(0...DATA.length)
      path = ROOT + DATA[index]
      break path unless game.sources.any? { |source| source.path == path }
    end
  end
end
