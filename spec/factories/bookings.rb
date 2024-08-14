FactoryBot.define do
  factory :booking do
    booking_date { "2024-08-13" }
    booking_start_time { "2024-08-13 14:47:29" }
    booking_cost { "9.99" }
    venue { nil }
    user { nil }
  end
end
