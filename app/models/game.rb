class Game < ApplicationRecord
  has_many :players, dependent: :destroy
  has_many :rounds,  dependent: :destroy
  has_many :templates, through: :rounds
  has_many :sources,   through: :players

  before_create :generate_join_code

  def generate_join_code
    self.join_code = loop do
      code = Random.new.rand(1000..9999)
      break code unless Game.exists? join_code: code
    end
  end
end
