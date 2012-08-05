class CreateTutorialTable < ActiveRecord::Migration
  def up
    create_table :tutorials do |t|
      t.string :completed
      t.datetime :created_at
      t.timestamps
    end
  end

  def down
  end
end
