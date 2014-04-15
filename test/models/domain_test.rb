require 'test_helper'

class DomainTest < ActiveSupport::TestCase
  should have_many(:projects)
  should validate_presence_of(:name)
  
  context "Within context" do
    setup do
      create_domains
    end
    teardown do
      destroy_domains
    end
    
    should "have a scope to alphabetize domains" do
      assert_equal ["Academic", "Personal", "Poetry", "Software"], Domain.alphabetical.map(&:name)
    end
    
    should "have a scope to select only active domains" do
      assert_equal ["Academic", "Personal", "Software"], Domain.active.map(&:name).sort
    end
    
    should "have a scope to select only inactive domains" do
      assert_equal ["Poetry"], Domain.inactive.alphabetical.map(&:name)
    end 
  end
end

