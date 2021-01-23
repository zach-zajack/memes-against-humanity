class Source < ApplicationRecord
  include ShitpostData

  belongs_to :player
  delegate :game, to: :player

  before_create :generate_source_path

  def played?
    self.order != -1
  end

  def hide
    update_attribute(:hidden, true)
  end

  private

  def generate_source_path
    self.path = loop do
      path = DOMAIN + DATA["sources"].values.shuffle.first
      break path unless game.sources.any? { |source| source.path == path }
    end
  end
end
