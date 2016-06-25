class Interest < ApplicationRecord
  attr_accessor :attending

  belongs_to :concert
  belongs_to :user
  belongs_to :like
end
