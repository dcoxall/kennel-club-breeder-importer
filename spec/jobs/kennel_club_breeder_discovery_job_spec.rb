require 'rails_helper'

RSpec.describe KennelClubBreederDiscoveryJob, type: :job do
  describe "#perform" do
    subject do
      VCR.use_cassette("kennel_club/breed_#{breed.name.downcase}") do
        described_class.new.perform(breed)
      end
    end

    context "for breeds with many breeders" do
      let(:breed) { create(:breed, name: "Boxer") }

      it "enqueues a KennelClubBreederImportJob for each breeder" do
        expect(KennelClubBreederImportJob).to receive(:perform_later)
          .exactly(90).times
        subject
      end
    end

    context "for breeds with few breeders" do
      let(:breed) { create(:breed, name: "Basenji") }

      it "enqueues a KennelClubBreederImportJob for each breeder" do
        expect(KennelClubBreederImportJob).to receive(:perform_later)
          .exactly(2).times
        subject
      end
    end
  end
end
