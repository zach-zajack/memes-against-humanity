class Template < ApplicationRecord
  belongs_to :round
  delegate :game, to: :round

  before_create :generate_template_data

  def data
    DATA[self.key]
  end

  def base
    ROOT + data["base"]
  end

  def overlay?
    data["overlay"].present?
  end

  def overlay
    ROOT + data["overlay"] if overlay?
  end

  def rects
    data["rects"]
  end

  def slots
    rects.count
  end

  private

  ROOT = "https://www.shitpostbot.com/img/templates/"
  DATA = JSON.parse(File.open("public/templates.json").read)

  def generate_template_data
    self.key = loop do
      index = Random.new.rand(0...DATA.length)
      key = DATA.keys[index]
      break key if game.templates.none? { |template| template.key == key }
    end
  end
end
