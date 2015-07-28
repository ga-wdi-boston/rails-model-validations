class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.references :person, index: true, foreign_key: true
      t.references :place, index: true, foreign_key: true
      t.date :from
      t.date :to
    end
  end
end
