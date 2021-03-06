require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  def setup
    do_cleanup
  end

  test 'dependent permissions get deleted' do
    3.times { create(:folder) }
    assert_equal Boxroom::Folder.all.count, 4 # Root folder gets created automatically

    group1 = create(:group)
    group2 = create(:group)
    assert_equal group1.permissions.count, 4
    assert_equal group2.permissions.count, 4
    assert_equal Boxroom::Permission.all.count, 8

    group1.destroy
    assert_equal Boxroom::Permission.all.count, 4

    group2.destroy
    assert_equal Boxroom::Permission.all.count, 0
  end

  test 'name is unique' do
    create(:group, :name => 'Users')
    assert Boxroom::Group.exists?(:name => 'Users')

    group = Boxroom::Group.new(:name => 'Users')
    assert !group.save
  end

  test 'name is not empty' do
    group = Boxroom::Group.new
    assert !group.save
  end

  test 'admin permissions get created' do
    create(:folder)
    assert Boxroom::Folder.all.count > 0

    group = create(:group, :name => 'Admins')
    assert_equal group.permissions.count, Boxroom::Folder.all.count

    group.permissions.each do |permission|
      assert permission.can_create
      assert permission.can_read
      assert permission.can_update
      assert permission.can_delete
    end
  end

  test 'permissions get created' do
    create(:folder)
    assert Boxroom::Folder.all.count > 0

    group = create(:group)
    assert_equal group.permissions.count, Boxroom::Folder.all.count

    group.permissions.each do |permission|
      assert !permission.can_create
      assert_equal permission.can_read, permission.folder.is_root?
      assert !permission.can_update
      assert !permission.can_delete
    end
  end

  test 'cannot delete admins group' do
    admins = create(:group, :name => 'Admins')
    normal_group = create(:group)

    assert admins.admins_group?
    assert_raise(RuntimeError) { admins.destroy }
    assert normal_group.destroy
  end
end
