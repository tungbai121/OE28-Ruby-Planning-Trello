FactoryBot.define do
  factory :comment do |f|
    f.content {Faker::Quote.famous_last_words}
    tag {FactoryBot.create :tag}
    user {FactoryBot.create :user}
  end
end
