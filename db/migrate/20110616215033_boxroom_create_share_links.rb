class BoxroomCreateShareLinks < ActiveRecord::Migration[5.0]
  def self.up
    create_table :boxroom_share_links do |t|
      t.string :emails
      t.string :link_token
      t.datetime :link_expires_at
      t.references :user_file
      t.timestamps
    end
  end

  def self.down
    drop_table :boxroom_share_links
  end
end
