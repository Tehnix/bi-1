class Like < ApplicationRecord
  belongs_to :interest
  belongs_to :owner, class_name: 'User'
end
