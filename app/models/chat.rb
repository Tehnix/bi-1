class Chat < ApplicationRecord
  has_and_belongs_to_many :users

  has_many :messages
  belongs_to :concert
end
