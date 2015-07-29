class AddCountryToPlace < ActiveRecord::Migration
  def change
    add_column :places, :country, :string
  end
end
