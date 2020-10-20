FactoryBot.define do
  factory :tag_label do |f|
    tag {FactoryBot.create :tag}
    label {FactoryBot.create :label}
  end
end
