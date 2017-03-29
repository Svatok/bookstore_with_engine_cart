FactoryGirl.define do
  factory :country do
    name { FFaker::Address.country }
    code '+38'
  end
end