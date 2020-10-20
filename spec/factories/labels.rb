FactoryBot.define do
  factory :label do |f|
    f.content {Faker::Lorem.characters number: 10}
    board {FactoryBot.create :board}
  end
end
