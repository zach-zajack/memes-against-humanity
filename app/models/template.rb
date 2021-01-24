class Template < ApplicationRecord
  include ShitpostData

  belongs_to :round
  delegate :game, to: :round

  before_create :generate_template_data

  def data
    DATA["templates"][self.name]
  end

  def base
    DOMAIN + data["template"]
  end

  def use_overlay?
    data.key?("overlay")
  end

  def overlay
    DOMAIN + data["overlay"] if use_overlay?
  end

  def rects
    data["rects"]
  end

  def slots
    rects.count
  end

  private

  def generate_template_data
    self.name = loop do
      name = DATA["templates"].keys.shuffle.first
      break name if game.templates.none? { |template| template.name == name }
    end
  end
end
