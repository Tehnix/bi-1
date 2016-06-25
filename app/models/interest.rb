class Interest < ApplicationRecord
  belongs_to :concert
  belongs_to :user
  belongs_to :like
end
