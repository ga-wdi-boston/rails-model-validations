class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.references :company, index: true, foreign_key: true
      t.references :developer, index: true, foreign_key: true
      t.integer :salary
    end
  end
end
