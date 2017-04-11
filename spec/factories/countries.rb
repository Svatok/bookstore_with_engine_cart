FactoryGirl.define do
  factory :country, class: EngineCart::Country do
    name { FFaker::Address.country }
    phone_number {'+38'}
  end
end
