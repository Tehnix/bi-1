class User < ApplicationRecord
  attr_accessor :friend, :likes_you, :mutual_concerts

  has_and_belongs_to_many :chats

  has_many :interests
  has_many :concerts, through: :interests
  has_many :likes, through: :interests

  has_many :friendships
  has_many :friends, through: :friendships
  has_many :inverse_friendships, class_name: "Friendship", foreign_key: "friend_id"
  has_many :inverse_friends, through: :inverse_friendships, source: :user

  def friends
    super | inverse_friends
  end

  # Rely on authentication to save record?
  class << self
    def store_friends(current_user, me)
      friends = me.friends
      friend_users = []
      loop do
        friends.each do |friend|
          friend_users << User.create_with(picture: friend.picture.url)
                              .find_or_create_by(profile_id: friend.id)
        end

        friends = friends.next

        break if friends.empty?
      end
      current_user.friends = friend_users
    end
  end
end
