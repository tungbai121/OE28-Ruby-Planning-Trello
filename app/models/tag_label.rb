class TagLabel < ApplicationRecord
  belongs_to :tag
  belongs_to :label

  class << self
    def find_relation tag_id, label_id
      find_by tag_id: tag_id, label_id: label_id
    end
  end
end
