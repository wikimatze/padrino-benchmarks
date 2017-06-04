class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.string :name
      t.string :text
      t.timestamps null: false
    end
  end

  def self.down
    drop_table :posts
  end
end
