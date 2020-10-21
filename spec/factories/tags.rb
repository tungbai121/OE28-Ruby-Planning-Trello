FactoryBot.define do
  factory :tag do |f|
    f.name {Faker::Name.name}
    f.description {Faker::Lorem.paragraph}
    f.deadline {Faker::Time.between(from: DateTime.now, to: DateTime.now + 30)}
    list {FactoryBot.create :list}
  end
end
