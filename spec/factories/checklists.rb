FactoryBot.define do
  factory :checklist do |f|
    f.name {Faker::Name.name}
    tag {FactoryBot.create :tag}
  end
end
