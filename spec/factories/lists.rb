require "faker"

FactoryBot.define do
  factory :list do |f|
    f.name {Faker::Name.name}
    board {FactoryBot.create :board}
  end
end
