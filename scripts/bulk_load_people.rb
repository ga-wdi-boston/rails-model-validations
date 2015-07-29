require 'csv'

CSV.foreach('data/people.csv', headers: true) do |person|
  Person.create!(person.to_hash)
end
