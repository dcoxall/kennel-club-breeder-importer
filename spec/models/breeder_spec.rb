require 'rails_helper'

RSpec.describe Breeder, type: :model do
  describe "validation" do
    it "requires a name" do
      expect(build(:breeder, name: nil)).to_not be_valid
    end

    it "reference needs to be unique" do
      breeder = create(:breeder)
      expect(build(:breeder, reference: breeder.reference)).to_not be_valid
    end
  end

  it "can have multiple breeds" do
    expect(build(:breeder, breeds: [])).to be_valid
    expect(build(:breeder, breeds: [create(:breed)])).to be_valid
    expect(build(:breeder, breeds: create_list(:breed, 2))).to be_valid
  end

  it "geocodes location" do
    breeder = build(:breeder)
    expect {
      VCR.use_cassette("geocode/hitchin_hertfordshire") do
        breeder.location = "Hitchin, Hertfordshire"
        breeder.save
      end
    }.to change { [breeder.longitude, breeder.latitude] }
  end
end
