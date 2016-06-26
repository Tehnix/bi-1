class Interest < ApplicationRecord
  attr_accessor :attending

  belongs_to :concert
  belongs_to :user

  has_many :likes
end
