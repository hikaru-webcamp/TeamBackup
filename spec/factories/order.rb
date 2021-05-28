FactoryBot.define do
  factory :order do
    customer_id { 1 }
    shipping_fee { 800 }
    total_price { ((Product.find(1).price * 1.1).floor * Cart_product.find(1).quantity) + 800 }
    address_name { Gimei.kanji }
    address { Gimei.address.kanji }
    postal_code { Faker::Address.postcode }
  end
end