FactoryGirl.define do
  factory :breed do
    family
    sequence(:name) { |i| "Breed #{i}" }
    url do |breed|
      unless breed.name.blank?
        format("http://www.thekennelclub.org.uk/services/public/acbr/Default.aspx?breed=%{name}",
          name: CGI.escape(breed.name),
        )
      end
    end
  end
end
