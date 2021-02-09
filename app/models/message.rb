class Message < ApplicationRecord
  belongs_to :player

  after_create_commit { BroadcastGameJob.perform_later(player.game, :message) }

  validates_length_of :content, minimum: 1, maximum: 200

  def author
    player.name
  end
end
