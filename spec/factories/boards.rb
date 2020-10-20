require "faker"

FactoryBot.define do
  factory :board do |f|
    f.name {Faker::Name.name}
    f.description {Faker::Quote.famous_last_words}
    f.status {Faker::Boolean.boolean}
    f.closed {0}
  end
end
