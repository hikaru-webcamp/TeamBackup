FactoryBot.define do
  factory :address do
    customer_id { 1 }
    address_name { Gimei.kanji }
    address { Gimei.address.kanji }
    postal_code { Faker::Address.postcode }
  end
end