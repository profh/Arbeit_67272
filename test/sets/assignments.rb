module Contexts
  module Assignments
    # Context for assignments (assumes contexts for [projects, domains], users)
    def create_assignments
      @arbeit_ed        = FactoryGirl.create(:assignment, project: @arbeit, user: @ed)
      @arbeit_ted       = FactoryGirl.create(:assignment, project: @arbeit, user: @ted)
      @arbeit_fred      = FactoryGirl.create(:assignment, project: @arbeit, user: @fred)
      @bookmanager_ed   = FactoryGirl.create(:assignment, project: @bookmanager, user: @ed, active: false)
      @bookmanager_ted  = FactoryGirl.create(:assignment, project: @bookmanager, user: @ted)
      @bookmanager_fred = FactoryGirl.create(:assignment, project: @bookmanager, user: @fred)
      @proverbs_ed      = FactoryGirl.create(:assignment, project: @proverbs, user: @ed)
      @proverbs_ted     = FactoryGirl.create(:assignment, project: @proverbs, user: @ted)
    end
    
    def destroy_assignments
      @arbeit_ed.destroy
      @arbeit_ted.destroy
      @arbeit_fred.destroy
      @bookmanager_ed.destroy
      @bookmanager_ted.destroy
      @bookmanager_fred.destroy
      @proverbs_ed.destroy
      @proverbs_ted.destroy
    end
  end
end