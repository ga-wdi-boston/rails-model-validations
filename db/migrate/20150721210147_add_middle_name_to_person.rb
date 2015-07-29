class AddMiddleNameToPerson < ActiveRecord::Migration
  def change
    add_column :people, :middle_name, :string
  end
end