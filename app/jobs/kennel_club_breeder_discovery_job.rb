class KennelClubBreederDiscoveryJob < ActiveJob::Base
  COUNTY_SELECTOR       = "div.p > a:nth-child(1)".freeze
  BREEDER_LINK_SELECTOR = "tr > td:nth-child(1) > a:nth-child(1)".freeze

  queue_as :import

  def perform(breed)
    web  = Mechanize.new { |m| m.user_agent_alias = 'Mac Firefox' }
    page = web.get(breed.url)
    counties = page.search(COUNTY_SELECTOR).map do |element|
      CGI.escape(element.content.strip)
    end
    if counties.empty?
      detect_breeders_on_page(page)
    else
      counties.each do |county|
        url = breed.url + format("&county=%s", county)
        county_page = web.get(url)
        detect_breeders_on_page(county_page)
      end
    end
  end

  private

  def detect_breeders_on_page(page)
    page.search(BREEDER_LINK_SELECTOR).each do |element|
      KennelClubBreederImportJob.perform_later(
        element[:href].scan(/id=(\d+)/)[0][0]
      )
    end
  end
end
