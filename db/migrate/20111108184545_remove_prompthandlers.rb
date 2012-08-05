class RemovePrompthandlers < ActiveRecord::Migration
  def self.up
    drop_table :prompthandlers
  end

  def self.down
    create_table :prompthandlers do |t|
      t.string :command
      t.string :params
      t.timestamps
     end
  end
end
