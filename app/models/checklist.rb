class Checklist < ApplicationRecord
  CHECKLIST_PARAMS = %i(name checked).freeze

  belongs_to :tag

  validates :name, presence: true,
    length: {maximum: Settings.checklist.name.length}

  scope :checked, ->{where checked: true}
  scope :unchecked, ->{where checked: false}
end
