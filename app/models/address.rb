class Address < ActiveRecord::Base
  belongs_to :person, inverse_of: :addresses
  belongs_to :place, inverse_of: :addresses
end
