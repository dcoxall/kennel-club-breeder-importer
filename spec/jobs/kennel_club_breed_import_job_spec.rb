require 'rails_helper'

RSpec.describe KennelClubBreedImportJob, type: :job do
  describe "#perform" do
    let!(:family) { create(:family, name: "Dog") }

    subject do
      VCR.use_cassette("kennel_club/breeds") do
        described_class.new.perform(family)
      end
    end

    it "sets the breed names" do
      expect { subject }.to change {
        family.breeds.pluck(:name)
      }.to include("Akita", "Boxer", "Collie (Rough)")
    end

    it "identifies all breeds" do
      expect { subject }.to change(family.breeds, :count).from(0).to(215)
    end

    it "sets the breed URLs" do
      expect { subject }.to change {
        family.breeds.pluck(:url)
      }.to include(
        "http://www.thekennelclub.org.uk/services/public/acbr/Default.aspx?breed=Entlebucher+Mountain+Dog+(Imp)",
        "http://www.thekennelclub.org.uk/services/public/acbr/Default.aspx?breed=Boxer",
        "http://www.thekennelclub.org.uk/services/public/acbr/Default.aspx?breed=West+Highland+White+Terrier",
        "http://www.thekennelclub.org.uk/services/public/acbr/Default.aspx?breed=Griffon+Fauve+De+Bretagne+(Imp)",
      )
    end
  end
end
