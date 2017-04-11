FactoryGirl.define do
  factory :order_item, class: EngineCart::OrderItem do
    quantity 1
    association :product
    association :order
  end
end