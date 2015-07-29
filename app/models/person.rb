class Person < ActiveRecord::Base
  has_many :pets, inverse_of: :person
  belongs_to :place, inverse_of: :people
end
