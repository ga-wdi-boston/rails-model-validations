class Place < ActiveRecord::Base
  has_many :people, inverse_of: :place
end
