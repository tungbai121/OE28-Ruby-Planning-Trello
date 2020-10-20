FactoryBot.define do
  factory :tag_user do |f|
    tag {FactoryBot.create :tag}
    user {FactoryBot.create :user}
  end
end
