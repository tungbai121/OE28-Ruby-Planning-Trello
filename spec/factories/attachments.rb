FactoryBot.define do
  factory :attachment do |f|
    f.name {Faker::Name.name}
    f.content {Rack::Test::UploadedFile.new "#{Rails.root}/spec/fixtures/files/avatar.jpg"}
  end
end
