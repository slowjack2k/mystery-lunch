FactoryBot.define do
  factory :employee do
    name { "#{FFaker::Name.first_name} #{FFaker::Name.last_name}" }
    department { "development" }
  end
end
