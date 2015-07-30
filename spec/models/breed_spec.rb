require 'rails_helper'

RSpec.describe Breed, type: :model do
  describe "validation" do
    it "requires a Family" do
      breed = build(:breed)
      expect {
        breed.family = nil
      }.to change(breed, :valid?).from(true).to(false)
    end

    it "requires a name" do
      expect(build(:breed, name: nil)).to_not be_valid
    end
  end

  it "can have multiple breeders" do
    breed    = create(:breed)
    breeders = create_list(:breeder, 2, breeds: [breed])
    expect(breed.breeders.count).to eql(2)
  end
end
