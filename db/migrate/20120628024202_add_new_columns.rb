class AddNewColumns < ActiveRecord::Migration
  def up
    add_column :tutorials, :show_success_for, :string
    add_column :tutorials, :show_correction_for, :string
    add_column :tutorials, :show_summary, :string
  end

  def down
  end
end
