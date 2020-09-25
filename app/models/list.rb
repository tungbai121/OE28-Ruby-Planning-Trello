class List < ApplicationRecord
  PERMIT_ATTRIBUTES = %i(name).freeze

  has_many :tags, ->{order :position}, dependent: :destroy
  belongs_to :board

  validates :name, presence: true,
    length: {maximum: Settings.validate.max_list_name}

  scope :opened, ->{where closed: false}
end
