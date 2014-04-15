module Contexts
  module Domains
    # Context for domains
    def create_domains
      @software = FactoryGirl.create(:domain)
      @academic = FactoryGirl.create(:domain, name: 'Academic')
      @personal = FactoryGirl.create(:domain, name: 'Personal')
      @poetry   = FactoryGirl.create(:domain, name: 'Poetry', active: false)
    end
    
    def destroy_domains
      @software.destroy
      @academic.destroy
      @personal.destroy
      @poetry.destroy
    end
  end
end