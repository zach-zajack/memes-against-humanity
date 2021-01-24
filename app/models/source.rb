class Source < ApplicationRecord
  include ShitpostData

  belongs_to :player
  delegate :game, to: :player

  before_create :generate_source_path

  def path
    DOMAIN + DATA["sources"][self.name]
  end

  private

  def generate_source_path
    self.name = loop do
      name = DATA["sources"].keys.shuffle.first
      break name if game.sources.none? { |source| source.name == name }
    end
  end
end
