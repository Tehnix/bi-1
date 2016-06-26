class Chat < ApplicationRecord
  attr_accessor :recent_message, :excluded_participants,
                :unread_count

  has_many :chat_connections
  has_many :participants, through: :chat_connections, class_name: 'User',
           source: :user, foreign_key: 'participant_id'
  has_many :messages

  belongs_to :concert
end
