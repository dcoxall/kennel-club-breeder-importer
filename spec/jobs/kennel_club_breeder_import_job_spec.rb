require 'rails_helper'

RSpec.describe KennelClubBreederImportJob, type: :job do
  describe "#perform" do
    let!(:family) { create(:family, name: "Dog") }

    subject do
      VCR.use_cassette("kennel_club/breeder_#{kennel_club_id}", record: :new_episodes) do
        described_class.new.perform(kennel_club_id)
      end
    end

    context "with a kennel club breeder with '(Imp)' breeds" do
      let(:kennel_club_id) { 198939 }

      before do
        create(:breed, name: "Akita", family: family)
        create(:breed, name: "Korean Jindo", family: family) # Imp
        create(:breed, name: "Beauceron", family: family)
      end

      it "associates the '(Imp)' breed to the breeder" do
        expect { subject }.to change {
          Breeder.find_by(reference: kennel_club_id).try { |breeder|
            breeder.breeds.pluck(:name).sort
          }
        }.to(["Akita", "Beauceron", "Korean Jindo"])
      end
    end

    context "with a valid kennel club breeder id" do
      let(:kennel_club_id) { 88776 }

      before do
        create(:breed, name: "Affenpinscher", family: family)
        create(:breed, name: "Irish Terrier", family: family)
      end

      it "sets the breeder name" do
        expect { subject }.to change {
          Breeder.find_by(reference: kennel_club_id).try(:name)
        }.to("Mrs J T Fletcher")
      end

      it "sets the breeder reference" do
        expect { subject }.to change {
          Breeder.find_by(reference: kennel_club_id).try(:reference)
        }.to(kennel_club_id.to_s)
      end

      it "sets the breeder phone number" do
        expect { subject }.to change {
          Breeder.find_by(reference: kennel_club_id).try(:phone_number)
        }.to("01189 744780")
      end

      it "sets the breeder location" do
        expect { subject }.to change {
          Breeder.find_by(reference: kennel_club_id).try(:location)
        }.to("Reading, Berkshire")
      end

      it "sets the breeders supported breeds" do
        expect { subject }.to change {
          Breeder.find_by(reference: kennel_club_id).try { |breeder|
            breeder.breeds.pluck(:name).sort
          }
        }.to(["Affenpinscher", "Irish Terrier"])
      end
    end

    context "with puppies for sale" do
      let(:kennel_club_id) { 258978 }
      before { create(:breed, name: "Collie (Rough)", family: family) }

      it "includes the listed litters" do
        expect { subject }.to change {
          Breeder.find_by(reference: kennel_club_id).try { |breeder|
            breeder.selling.pluck(:name)
          }
        }.to match_array(["Collie (Rough)"])
      end
    end
  end
end
