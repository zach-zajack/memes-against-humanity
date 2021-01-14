class Round < ApplicationRecord
  belongs_to :game
  has_one    :template, dependent: :destroy
  has_many   :memes,    dependent: :destroy
end
