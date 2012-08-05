class CreateInputs < ActiveRecord::Migration
  def change
    create_table :inputs do |t|
      t.string :text
      t.datetime :created_at

      t.timestamps
    end
  end
end
