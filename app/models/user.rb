class User < ApplicationRecord
  has_and_belongs_to_many :chats

  has_many :interests
  has_many :concerts, through: :interests

  has_many :friendships
  has_many :friends, through: :friendships

  has_many :inverse_friendships, class_name: "Friendship", foreign_key: "friend_id"
  has_many :inverse_friends, through: :inverse_friendships, source: :user

  def friends
    super | inverse_friends
  end
end
