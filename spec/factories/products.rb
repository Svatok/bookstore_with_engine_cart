FactoryGirl.define do
  factory :product do
    initialize_with { new.decorate }
    title { FFaker::Book.title }
    description { FFaker::Book.description }
    product_type 'product'
    status 'active'
    
    trait :with_authors do
      authors { create_list :author, 2 }
    end
    
    trait :in_stock do
      stocks { create :stock }
    end

    trait :with_orders do
      order_items { create :order_item }
    end

    trait :coupon do
      title { Date.time.to_s }
      product_type 'coupon'
      description ''
      prices { create priceable :price, :for_coupon }
    end

  factory :full_product, traits: [:with_authors, :in_stock]
  
  end
end