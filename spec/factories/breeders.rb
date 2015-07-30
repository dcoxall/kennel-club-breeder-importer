FactoryGirl.define do
  factory :breeder do
    name         "Mr D Coxall"
    sequence(:reference) { |i| i.to_s }
    last_seen_at DateTime.now
    after(:build) do |breeder|
      breeder.breeds << FactoryGirl.create(:breed)
    end
  end
end
