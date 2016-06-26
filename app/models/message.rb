class Message < ApplicationRecord
  attr_accessor :position

  belongs_to :chat
  belongs_to :author, class_name: 'User'

  # has_many :readers
  # has_many :users, through: :readers
end
