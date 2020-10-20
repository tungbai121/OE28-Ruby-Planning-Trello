require "faker"

FactoryBot.define do
  factory :label do |f|
    f.content {Faker::Name.name}
    board {FactoryBot.create :board}
  end
end
