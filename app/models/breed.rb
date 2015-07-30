class Breed < ActiveRecord::Base
  belongs_to :family
  has_and_belongs_to_many :breeders

  has_many :litters
  has_many :sellers, through: :litters, source: :breeder

  validates :name, presence: true
  validates :family, presence: true
end
