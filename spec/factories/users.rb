FactoryGirl.define do
  factory :user do
    email { FFaker::Internet.email }
    password 'TestPassword2017'
    after(:create) do |user|
      user.confirmed_at = Time.now
      user.save
    end
      
    trait :not_confirmed do
      after(:create) do |user|
        user.confirmed_at = nil
        user.save
      end
    end
    
    trait :admin do
      role 'admin'
    end    
    
  end
end