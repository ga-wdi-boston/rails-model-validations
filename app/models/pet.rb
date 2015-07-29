class Pet < ActiveRecord::Base
  belongs_to :person, inverse_of: :pets
end
