require "faker"

FactoryBot.define do
  factory :activity do |f|
    f.action {Faker::Quote.famous_last_words}
    user {FactoryBot.create :user}
    board {FactoryBot.create :board}
    created_at {Faker::Date.between(from: "1970-09-23", to: "2010-08-25")}
    updated_at {Faker::Date.between(from: "1970-09-23", to: "2010-08-25")}
  end
end
