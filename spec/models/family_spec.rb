require 'rails_helper'

RSpec.describe Family, type: :model do
  describe "validation" do
    it "requires a unique name" do
      create(:family, name: 'Dog')
      expect(build(:family, name: 'Cat')).to be_valid
      expect(build(:family, name: 'Dog')).to_not be_valid
    end
  end
end
