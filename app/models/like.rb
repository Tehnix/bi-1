class Like < ApplicationRecord
  has_many :interests
  has_many :strangers, through: :interests, class_name: 'User'
end
