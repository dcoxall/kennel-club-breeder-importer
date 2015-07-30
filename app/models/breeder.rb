class Breeder < ActiveRecord::Base
  has_and_belongs_to_many :breeds

  has_many :litters
  has_many :selling, through: :litters, source: :breed

  validates :name, presence: true
  validates :reference, uniqueness: true

  geocoded_by :location
  after_validation :geocode, if: :requires_geocoding?

  private

  def requires_geocoding?
    location.present? && location_changed?
  end
end
