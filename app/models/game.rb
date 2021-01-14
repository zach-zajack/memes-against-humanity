class Game < ApplicationRecord
  has_many :players, dependent: :destroy
  has_many :rounds,  dependent: :destroy
  has_many :templates, through: :rounds
  has_many :sources,   through: :players
end
