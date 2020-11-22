class CardLabel < ApplicationRecord
  belongs_to :card
  belongs_to :label

  class << self
    def find_relation card_id, label_id
      find_by card_id: card_id, label_id: label_id
    end
  end
end
