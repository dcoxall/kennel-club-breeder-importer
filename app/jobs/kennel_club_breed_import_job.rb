class KennelClubBreedImportJob < ActiveJob::Base
  URL = "http://www.thekennelclub.org.uk/services/public/acbr/Default.aspx".freeze

  BREED_SELECTOR = "div.p a".freeze

  queue_as :import

  def perform(family)
    web  = Mechanize.new { |m| m.user_agent_alias = 'Mac Firefox' }
    page = web.get(URL)

    page.search(BREED_SELECTOR).each do |element|
      breed     = family.breeds.find_or_initialize_by(name: element.content.strip)
      breed.url = (URI(URL) + element[:href]).to_s
      breed.save!
    end
  end
end
