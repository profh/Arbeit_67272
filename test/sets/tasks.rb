module Contexts
  module Tasks
    # Context for tasks (assumes contexts for [projects, domains], users)
    def create_tasks
      @arbeit_t1      = FactoryGirl.create(:task, project: @arbeit, creator: @ed, completer: @ed)
      @arbeit_t2      = FactoryGirl.create(:task, name: 'Wireframing', project: @arbeit, due_on: 1.day.from_now, due_string: "tomorrow", creator: @ted, completer: nil, completed: false)
      @arbeit_t3      = FactoryGirl.create(:task, name: 'Create stylesheets', project: @arbeit, due_on: 3.days.from_now, due_string: "3 days ago", creator: @ted, completer: nil, completed: false)
      @proverbs_t1    = FactoryGirl.create(:task, name: 'Unit testing', project: @proverbs, due_on: 5.days.ago, due_string: "5 days ago", creator: @ted, completer: @ted, completed: true)
      @bookmanager_t1 = FactoryGirl.create(:task, name: 'Modify controllers', project: @bookmanager, due_on: 4.days.ago, due_string: "4 days ago", creator: @fred, completer: @fred, completed: true, priority: 2)
      @bookmanager_t2 = FactoryGirl.create(:task, name: 'User testing', project: @bookmanager, due_on: 3.days.ago, due_string: "3 days ago", creator: @ted, completer: @fred, completed: true)
      @bookmanager_t3 = FactoryGirl.create(:task, name: 'Security review', project: @bookmanager, due_on: 2.days.ago, due_string: "2 days ago", creator: @fred, completer: nil, completed: false)
    end
    
    def destroy_tasks
      @arbeit_t1.destroy
      @arbeit_t2.destroy
      @arbeit_t3.destroy
      @proverbs_t1.destroy
      @bookmanager_t1.destroy
      @bookmanager_t2.destroy
      @bookmanager_t3.destroy
    end
  end
end