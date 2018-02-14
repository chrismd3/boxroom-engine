class BoxroomDropColumnUserIdFromUserFiles < ActiveRecord::Migration[5.0]
  def self.up
    remove_column :boxroom_user_files, :user_id
  end

  def self.down
    add_column :boxroom_user_files, :user_id, :integer
  end
end
