class List < ApplicationRecord
  has_many :tags, ->{order :position}, dependent: :destroy
  belongs_to :board

  scope :opened, ->{where closed: false}
end
