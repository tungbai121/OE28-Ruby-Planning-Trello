class Checklist < ApplicationRecord
  CHECKLIST_PARAMS = %i(name).freeze

  belongs_to :card

  validates :name, presence: true,
    length: {maximum: Settings.checklist.name.length}

  scope :checked, ->{where checked: true}
  scope :unchecked, ->{where checked: false}
end
