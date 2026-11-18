FactoryBot.define do
  factory :admin_user do
    sequence(:email) { |n| "operator#{n}@example.test" }
    password { "spec-password-123" }
  end

  factory :property do
    sequence(:title) { |n| "Property #{n}" }
  end

  factory :tag do
    sequence(:title) { |n| "Tag #{n}" }
    sequence(:hashtag) { |n| "tag_#{n}" }
  end

  factory :category do
    sequence(:title) { |n| "Category #{n}" }
  end

  factory :neighbourhood do
    sequence(:title) { |n| "Neighbourhood #{n}" }
    tag
    published { true }
  end

  factory :property_neighbourhood do
    property
    neighbourhood
    published { true }
  end

  factory :city_gem do
    sequence(:title) { |n| "City Gem #{n}" }
    short_desc { "A local spot worth visiting." }
    location { "123 Example Street" }
    neighbourhood
    category
    tag
    published { true }
  end
end
