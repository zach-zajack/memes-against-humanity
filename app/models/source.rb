class Source < ApplicationRecord
  belongs_to :player
  delegate :game, to: :player

  before_create :generate_source_path

  private

  ROOT = "https://www.shitpostbot.com/img/sourceimages/"
  DATA = JSON.parse(File.open("public/sources.json").read)

  def generate_source_path
    self.path = loop do
      index = Random.new.rand(0...DATA.length)
      path = ROOT + DATA[index]
      break path unless game.sources.any? { |source| source.path == path }
    end
  end
end
