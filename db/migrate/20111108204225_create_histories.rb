class CreateHistories < ActiveRecord::Migration
  def self.up
    create_table :histories do |t|
      t.integer :user_id
      t.integer :command_id

      t.timestamps
    end
  end

  def self.down
    drop_table :histories
  end
end
