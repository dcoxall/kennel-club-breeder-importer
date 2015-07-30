FactoryGirl.define do
  factory :family do
    sequence(:name) { |i| "Animal #{i}" }
  end
end
