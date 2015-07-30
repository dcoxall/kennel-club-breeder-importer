class Family < ActiveRecord::Base
  has_many :breeds
  validates :name, presence: true, uniqueness: true
end
