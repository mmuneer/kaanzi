class AddBusinessLocationToCommands < ActiveRecord::Migration
  def change
    add_column :commands,:business, :string
    add_column :commands,:location, :string
  end
end
