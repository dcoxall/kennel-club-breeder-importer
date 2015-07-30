class Litter < ActiveRecord::Base
  belongs_to :breeder
  belongs_to :breed
end
