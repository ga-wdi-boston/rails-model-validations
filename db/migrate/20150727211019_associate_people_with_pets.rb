class AssociatePeopleWithPets < ActiveRecord::Migration
  def change
    add_column :pets, :person_id, :integer
    add_index :pets, :person_id
    add_foreign_key :pets, :people
  end
end
