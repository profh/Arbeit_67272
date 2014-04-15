module Contexts
  module Users
    # Context for users
    def create_users
      @ed   = FactoryGirl.create(:user)
      @ted  = FactoryGirl.create(:user, first_name: "Ted")
      @fred = FactoryGirl.create(:user, first_name: "Fred", role: "admin", email: "fred@example.com")
      @ned  = FactoryGirl.create(:user, first_name: "Ned", active: false)
    end
    
    def destroy_users
      @ed.destroy
      @ted.destroy
      @fred.destroy
      @ned.destroy
    end
  end
end