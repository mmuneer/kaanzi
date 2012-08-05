class CreatePrompthandlers < ActiveRecord::Migration
  def self.up
    create_table :prompthandlers do |t|
      t.string :command
      t.string :params

      t.timestamps
    end
  end

  def self.down
    drop_table :prompthandlers
  end
end
