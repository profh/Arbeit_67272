require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # Using matchers...
  should have_secure_password

  should have_many(:assignments)
  should have_many(:projects).through(:assignments)
  should have_many(:completed_tasks)
  should have_many(:created_tasks)
  
  should validate_presence_of(:first_name)
  should validate_presence_of(:last_name)
  should validate_presence_of(:email)
  
  should allow_value("fred@fred.com").for(:email)
  should allow_value("fred@andrew.cmu.edu").for(:email)
  should allow_value("my_fred@fred.org").for(:email)
  should allow_value("fred123@fred.gov").for(:email)
  should allow_value("my.fred@fred.net").for(:email)
  
  should_not allow_value("fred").for(:email)
  should_not allow_value("fred@fred,com").for(:email)
  should_not allow_value("fred@fred.uk").for(:email)
  should_not allow_value("my fred@fred.com").for(:email)
  should_not allow_value("fred@fred.con").for(:email)
  
  # Using context...
  context "Within context" do
    setup do
      create_users
    end
    teardown do
      destroy_users
    end
    
    should "have working name method" do 
      assert_equal "Gruberman, Ed", @ed.name
    end
    
    should "have working proper_name method" do 
      assert_equal "Ed Gruberman", @ed.proper_name
    end
    
    should "have working role? method" do 
      assert @ed.role?(:member)
      deny @ed.role?(:admin)
      assert @fred.role?(:admin)
    end
    
    should "have working class method for authenication" do 
      assert User.authenticate("fred@example.com", "secret")
      deny User.authenticate("fred@example.com", "password")
    end
    
    should "have a scope to alphabetize users" do
      assert_equal ["Ed", "Fred", "Ned", "Ted"], User.alphabetical.map(&:first_name)
    end
    
    should "have a scope to select only active domains" do
      assert_equal ["Ed", "Fred", "Ted"], User.active.alphabetical.map(&:first_name)
    end
    
    should "have a scope to select only inactive domains" do
      assert_equal ["Ned"], User.inactive.alphabetical.map(&:first_name)
    end 
    
    should "require users to have unique emails" do
      bad_user = FactoryGirl.build(:user, first_name: "Sed", email: "fred@example.com")
      deny bad_user.valid?
    end
    
    should "require a password for new users" do
      bad_user = FactoryGirl.build(:user, first_name: "Sed", password: nil)
      deny bad_user.valid?
    end
    
    should "require passwords to be confirmed and matching" do
      bad_user_1 = FactoryGirl.build(:user, first_name: "Sed", password: "secret", password_confirmation: nil)
      deny bad_user_1.valid?
      bad_user_2 = FactoryGirl.build(:user, first_name: "Sed", password: "secret", password_confirmation: "sauce")
      deny bad_user_2.valid?
    end
    
    should "require passwords to be at least four characters" do
      bad_user = FactoryGirl.build(:user, first_name: "Sed", password: "no")
      deny bad_user.valid?
    end
  end
end
