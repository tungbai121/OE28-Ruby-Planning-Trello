require "faker"

FactoryBot.define do
  factory :list do |f|
    f.name {Faker::Name.name}
    f.position {Faker::Number.between(from: 0, to: 20)}
    board {FactoryBot.create :board}
  end
end
