class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :surname
      t.string :given_name
      t.string :gender
      t.string :dob

      t.timestamps null: false
    end
  end
end