FactoryGirl.define do
  factory :review do
    rate 5
    reviewer_name { FFaker::NameMX.full_name }
    review_text { FFaker::HealthcareIpsum.paragraph }
    association :product
  end
end