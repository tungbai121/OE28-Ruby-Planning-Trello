class List < ApplicationRecord
  has_many :tags, dependent: :delete_all
  belongs_to :board
end
