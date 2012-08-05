class CreateTwitterAuths < ActiveRecord::Migration
  def self.up
    create_table :twitter_auths do |t|
      t.string :user
      t.string :atoken
      t.string :asecret

      t.timestamps
    end
  end

  def self.down
    drop_table :twitter_auths
  end
end
