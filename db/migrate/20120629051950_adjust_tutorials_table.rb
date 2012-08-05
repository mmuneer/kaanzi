class AdjustTutorialsTable < ActiveRecord::Migration
  def up
    add_column :tutorials, :show_discovered_for, :string
    add_column :tutorials, :target, :string
    remove_column :tutorials, :show_correction_for
  end

  def down
    add_column :tutorials, :show_correction_for, :string
    remove_column :tutorials, :show_discovered_for
    remove_column :tutorials, :target
  end
end
