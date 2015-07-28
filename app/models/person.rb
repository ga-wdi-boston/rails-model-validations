class Person < ActiveRecord::Base
  has_many :pets, inverse_of: :person

  has_many :places, through: :addresses
  has_many :addresses
end
