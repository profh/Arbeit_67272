require 'test_helper'

class AssignmentTest < ActiveSupport::TestCase
  # Using matchers...
  should belong_to(:project)
  should belong_to(:user)
  
  # Using context...
  context "Within context" do
    setup do
      create_domains
      create_users
      create_projects
      create_assignments
    end
    teardown do
      destroy_domains
      destroy_users
      destroy_projects
      destroy_assignments
    end
    
    should "have a scope to select only active assignments" do
      assert_equal 7, Assignment.active.all.size
    end
    
    should "have a scope to select only inactive assignments" do
      assert_equal 1, Assignment.inactive.all.size
    end
        
    should "have a scope to find assignments for a given project" do
      assert_equal 3, Assignment.for_project(@arbeit.id).all.size
      assert_equal 2, Assignment.for_project(@proverbs.id).all.size
    end
    
    should "have a scope to find assignments for a given user" do
      assert_equal 3, Assignment.for_user(@ted.id).all.size
      assert_equal 2, Assignment.for_user(@fred.id).all.size
    end
    
    should "have a scope to order assignments by user" do
      assert_equal "Ed Gruberman", Assignment.by_user.first.user.proper_name
      assert_equal "Ted Gruberman", Assignment.by_user.last.user.proper_name
    end
    
    should "have a scope to order assignments by project" do
      assert_equal "Arbeit", Assignment.by_project.first.project.name
      assert_equal "Proverbs", Assignment.by_project.last.project.name
    end
    
    should "not allow assignments for inactive users" do
      @bad_assignment = FactoryGirl.build(:assignment, project: @arbeit, user: @ned)
      deny @bad_assignment.valid?
    end
    
    should "not allow assignments to projects that are not current" do
      @bad_assignment = FactoryGirl.build(:assignment, project: @choretracker, user: @ed)
      deny @bad_assignment.valid?
    end

    should "have a method to make an assignment inactive" do
      @bookmanager_ted.make_inactive
      deny @bookmanager_ted.active
    end

    should "have a method to make an inactive assignment active" do
      @bookmanager_ed.make_active
      assert @bookmanager_ed.active
    end
  end
end
