class BoxroomCreateFolders < ActiveRecord::Migration[5.0]
  def self.up
    create_table :boxroom_folders do |t|
      t.string :name
      t.references :user
      t.references :parent
      t.timestamps
    end
  end

  def self.down
    drop_table :boxroom_folders
  end
end
