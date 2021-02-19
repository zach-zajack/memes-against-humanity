class Message < ApplicationRecord
  belongs_to :player
  belongs_to :game, -> { with_deleted }

  after_create_commit { BroadcastMessageJob.perform_later(player.game, self) }

  validates_length_of :content, minimum: 1, maximum: 200
  validate :spam

  def author
    player.name
  end

  def player
    Player.unscoped { super }
  end

  private

  def spam
    last_msg = player.messages.last
    return if last_msg.nil? || Time.now - last_msg.created_at > 0.5.seconds
    errors.add(:base, "you are sending messages too quickly")
  end
end
