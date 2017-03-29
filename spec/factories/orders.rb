FactoryGirl.define do
  factory :order do

    trait :with_coupon do
      after(:create) do |order|
        create(:coupon, order: order)
        order.save
      end
    end
    
    trait :with_items do
      order_items { create_list(:order_item, 2) }
    end
    
    trait :with_addresses do
      after(:create) do |order|
        create([:address_with_type, :billing], addressable: order)
        create([:address_with_type, :shipping], addressable: order)
      end
    end

    trait :with_shipping do
      after(:create) do |order|
        create(:shipping, order: order)
        order.save
      end
    end


    trait :with_payment do
      after(:create) do |order|
        create(:payment, order: order)
        order.save
      end
    end
    
  end
end