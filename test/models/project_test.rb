require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  # Using matchers...
  should belong_to(:domain)
  should have_many(:tasks)
  should have_many(:assignments)
  should belong_to(:manager)
  should have_many(:users).through(:assignments)

  should accept_nested_attributes_for(:tasks).allow_destroy(true)
  
  should validate_presence_of(:name)
  should allow_value(Date.today).for(:start_date)
  should allow_value(1.day.ago.to_date).for(:start_date)
  should allow_value(1.day.from_now.to_date).for(:start_date)
  should_not allow_value("bad").for(:start_date)
  should_not allow_value(2).for(:start_date)
  should_not allow_value(3.14159).for(:start_date)
  
  should allow_value(nil).for(:end_date)
  should_not allow_value("bad").for(:end_date)
  should_not allow_value(2).for(:end_date)
  should_not allow_value(3.14159).for(:end_date)
  
  # Using context...
  context "Within context" do
    setup do
      create_domains
      create_users
      create_projects
    end
    teardown do
      destroy_domains
      destroy_users
      destroy_projects
    end
    
    should "have working is_active? method" do 
      assert @arbeit.is_active?
      assert @proverbs.is_active?
      assert @bookmanager.is_active?
      deny @choretracker.is_active?
    end
    
    should "have a scope to alphabetize projects" do
      assert_equal ["Arbeit", "BookManager", "ChoreTracker", "Proverbs"], Project.alphabetical.map(&:name)
    end
    
    should "have a scope to return all current projects" do
      assert_equal ["Arbeit", "BookManager", "Proverbs"], Project.current.map(&:name).sort
    end
    
    should "have a scope to return all past projects" do
      assert_equal ["ChoreTracker"], Project.past.map(&:name).sort
    end
    
    should "have a scope to return all projects with a similar name" do
      assert_equal "ChoreTracker", Project.for_name("chore").first.name
    end
    
    should "check to make sure the end date is after the start date" do
      @bad_project = FactoryGirl.build(:project, name: 'BogusProject', domain: @software, manager: @ed, start_date: 9.days.ago.to_date, end_date: 10.days.ago.to_date)
      deny @bad_project.valid?
    end 
    
    should "verify that the project's domain is active in the system" do
      @bad_project = FactoryGirl.build(:project, name: 'BogusProject', domain: @poetry, manager: @ed, start_date: Date.today, end_date: nil)
      deny @bad_project.valid?
    end 

    should "correctly assess if a project is destroyable" do
      create_assignments
      create_tasks
      deny @bookmanager.is_destroyable?, "#{@bookmanager.tasks.completed.size}"
      destroy_tasks
      destroy_assignments
    end

    should "set the end date to today when project ends" do
      assert_nil @bookmanager.end_date
      @bookmanager.end_project_now
      assert_equal Date.today, @bookmanager.end_date
    end

    should "remove incomplete tasks when project ends" do
      create_assignments
      create_tasks
      assert_equal 1, @bookmanager.tasks.incomplete.count
      @bookmanager.end_project_now
      assert_equal 0, @bookmanager.tasks.incomplete.count
      destroy_tasks
      destroy_assignments
    end

    should "not make inactive because of an improper edit" do
      create_assignments
      create_tasks
      assert_nil @bookmanager.end_date
      assert_equal 1, @bookmanager.tasks.incomplete.count
      @bookmanager.start_date = nil
      deny @bookmanager.valid?
      # try to save the invalid record; see that it is not saved (rollback)
      deny @bookmanager.save
      # verify that the rollback did not end the project or remove tasks
      assert_nil @bookmanager.end_date
      assert_equal 1, @bookmanager.tasks.incomplete.count
    end

    should "make assignments inactive when project ends" do
      create_assignments
      create_tasks
      assert_equal 1, @bookmanager.assignments.inactive.count
      @bookmanager.end_project_now
      assert_equal 3, @bookmanager.assignments.inactive.count
      destroy_tasks
      destroy_assignments
    end
  end
end

