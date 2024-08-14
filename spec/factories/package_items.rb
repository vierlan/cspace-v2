FactoryBot.define do
  factory :package_item do
    item { "MyString" }
    item_price { "9.99" }
    package { nil }
  end
end
