require 'test_helper'

class TaskTest < ActiveSupport::TestCase
  # Using matchers...
  should belong_to(:project)
  should belong_to(:creator)
  should belong_to(:completer)
  should have_many(:assignments).through(:project)
  
  should validate_presence_of(:name)
  should allow_value(1).for(:priority)
  should allow_value(2).for(:priority)
  should allow_value(3).for(:priority)
  should allow_value(4).for(:priority)
  should_not allow_value("bad").for(:priority)
  should_not allow_value(0).for(:priority)
  should_not allow_value(nil).for(:priority)

  
  # Using context...
  context "Within context" do
    setup do
      create_domains
      create_users
      create_projects
      create_assignments
      create_tasks
    end
    teardown do
      destroy_domains
      destroy_users
      destroy_projects
      destroy_assignments
      destroy_tasks
    end
    
    should "have working status method" do 
      assert_equal "Overdue", @bookmanager_t3.status
      assert_equal "Pending", @arbeit_t2.status
      assert_equal "Completed", @proverbs_t1.status
    end
    
    should "have a scope to order tasks chronologically" do
      assert_equal ['Unit testing', 'Modify controllers', 'Create stylesheets', 'User testing', 'Security review', 'Data modeling', 'Wireframing'], Task.chronological.map(&:name)
    end
    
    should "have a scope to return tasks that are overdue" do
      assert_equal ['Create stylesheets', 'Security review'], Task.overdue.map(&:name).sort
    end
    
    should "have a scope to return tasks that are upcoming" do
      assert_equal ['Wireframing'], Task.upcoming.map(&:name).sort
    end
    
    should "have a scope to return tasks that are completed" do
      assert_equal ['Data modeling', 'Modify controllers', 'Unit testing', 'User testing'], Task.completed.map(&:name).sort
    end
    
    should "have a scope to order tasks chronologically by completion date" do
      assert_equal ['User testing', 'Modify controllers', 'Unit testing', 'Data modeling'], Task.completed.by_completion_date.map(&:name)
    end
    
    should "have a scope to order tasks by priority" do
      assert_equal ['Unit testing', 'Create stylesheets', 'User testing', 'Security review', 'Data modeling', 'Wireframing', 'Modify controllers'], Task.by_priority.map(&:name)
    end
    
    should "have a scope to order tasks alphabetically by name" do
      assert_equal ['Create stylesheets', 'Data modeling', 'Modify controllers', 'Security review', 'Unit testing', 'User testing', 'Wireframing'], Task.by_name.map(&:name)
    end
    
    should "have a scope to return the last X tasks" do
      assert_equal ['Modify controllers', 'User testing'], Task.completed.last(2).map(&:name).sort
    end
    
    should "have a scope to return all high priority tasks" do
      assert_equal ['Create stylesheets', 'Data modeling', 'Security review', 'Unit testing', 'User testing', 'Wireframing'], Task.high_priority.map(&:name).sort
    end
    
    should "have a scope to return all medium priority tasks" do
      assert_equal ['Modify controllers'], Task.med_priority.map(&:name).sort
    end
    
    should "have a scope to return all tasks for a given project" do
      assert_equal ['Create stylesheets', 'Data modeling', 'Wireframing'], Task.for_project(@arbeit.id).map(&:name).sort
    end
    
    should "have a scope to return all tasks for a given creator" do
      assert_equal 1, Task.for_creator(@ed.id).size
      assert_equal 4, Task.for_creator(@ted.id).size
      assert_equal 2, Task.for_creator(@fred.id).size
    end
    
    should "have a scope to return all tasks for a given completer" do
      assert_equal 1, Task.for_completer(@ed.id).size
      assert_equal 1, Task.for_completer(@ted.id).size
      assert_equal 2, Task.for_completer(@fred.id).size
    end
    
    should "be able to process the due string into datetime or return error" do
      good_task = FactoryGirl.build(:task, name: 'Storyboarding', project: @arbeit, due_on: 1.day.from_now, due_string: "tomorrow", creator: @fred, completer: nil, completed: false)
      assert good_task.valid?
      bad_task = FactoryGirl.build(:task, name: 'Authenication', project: @arbeit, due_on: 3.days.from_now, due_string: "fred is dead", creator: @ted, completer: nil, completed: false)
      deny bad_task.valid?
    end
  end
end
