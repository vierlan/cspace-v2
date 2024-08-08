FactoryBot.define do
  factory :venue do
    name { "MyString" }
    amenities { "MyString" }
    address { "MyString" }
    district { "MyString" }
    categories { "MyString" }
    user { nil }
  end
end
