FactoryBot.define do
  sequence(:lunch_group) { |n| "lunch_group-#{n}" }

  factory :employee do
    name { "#{FFaker::Name.first_name} #{FFaker::Name.last_name}" }
    department { "development" }
    email { FFaker::Internet.email }
  end

  factory :participant do
    association :employee
    lunch_group { generate(:lunch_group) }
  end

  factory :lunch do
    year { 2022 }
    month { 1 }

    trait :with_participants do
      transient do
        participants_count { 3 }
      end

      participants do
        lunch_group = generate(:lunch_group)
        Array.new(participants_count) { association(:participant, lunch_group: lunch_group, lunch: instance) }
      end
    end
  end
end
