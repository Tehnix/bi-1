class Interest < ApplicationRecord
  belongs_to :concert
  belongs_to :user

  has_many :likes
  has_many :users, through: :likes
end
