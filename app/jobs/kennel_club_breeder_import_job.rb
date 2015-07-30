class KennelClubBreederImportJob < ActiveJob::Base
  URL = "http://www.thekennelclub.org.uk/services/public/acbr/display.aspx?id=%d".freeze

  NAME_SELECTOR     = "#ctl00_MainContent_DivAB > h1:nth-child(2)".freeze
  LOCATION_SELECTOR = "#ctl00_MainContent_LabelLocation".freeze
  BREED_SELECTOR    = "div.bg_white:nth-child(2) a".freeze
  PHONE_SELECTOR    = "#ctl00_MainContent_LabelPhone".freeze
  LITTER_SELECTOR   = "#ctl00_MainContent_TableSalesRegister [class] > td:nth-child(1)".freeze

  queue_as :import

  def perform(kennel_club_id)
    family  = Family.find_or_create_by!(name: "Dog")
    breeder = Breeder.find_or_initialize_by(reference: kennel_club_id.to_s)

    web  = Mechanize.new { |m| m.user_agent_alias = 'Mac Firefox' }
    page = web.get(format(URL, kennel_club_id))

    breeder.name         = page.search(NAME_SELECTOR).first.content.strip
    breeder.location     = page.search(LOCATION_SELECTOR).first.content.strip
    breeder.phone_number = page.search(PHONE_SELECTOR).first.content.strip
    breeder.breeds       = page.search(BREED_SELECTOR).map { |element|
      family.breeds.find_by(name: non_imp_name(element.content))
    }
    breeder.selling      = page.search(LITTER_SELECTOR).map { |element|
      family.breeds.find_by(name: non_imp_name(element.content))
    }
    breeder.last_seen_at = DateTime.current
    breeder.save!
  end

  private

  def non_imp_name(name)
    name.strip.scan(/^(.*?)( \(Imp\))?$/)[0][0]
  end
end
