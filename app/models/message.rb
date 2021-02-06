class Message < ApplicationRecord
  belongs_to :player

  after_create_commit :broadcast_message

  validates_length_of :content, minimum: 1, maximum: 200

  def author
    player.name
  end

  private

  def broadcast_message
    BroadcastGameJob.perform_later(player.game, "messages")
  end
end
