class Like < ApplicationRecord
  belongs_to :user
  belongs_to :stranger, class_name: 'User'
end
