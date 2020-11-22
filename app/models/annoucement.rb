class Annoucement < ApplicationRecord
  belongs_to :user
  belongs_to :annoucementable, polymorphic: true
end
