require "faker"

FactoryBot.define do
  factory :user do |f|
    f.name {Faker::Name.name}
    f.email {Faker::Internet.email}
    f.admin {Faker::Boolean.boolean}
    f.password {"password"}
    f.password_confirmation {"password"}
  end
end
