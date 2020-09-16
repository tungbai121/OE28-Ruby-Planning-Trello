class List < ApplicationRecord
  has_many :tags, dependent: :destroy
  belongs_to :board
end
