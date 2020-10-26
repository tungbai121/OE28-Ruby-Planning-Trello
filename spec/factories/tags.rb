FactoryBot.define do
  factory :tag do |f|
    f.name {Faker::Name.name}
    f.description {Faker::Lorem.paragraph}
    list {FactoryBot.create :list}
  end
end
