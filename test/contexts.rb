# require needed files
require './test/sets/domains'
require './test/sets/users'
require './test/sets/projects'
require './test/sets/assignments'
require './test/sets/tasks'

module Contexts
  # explicitly include all sets of contexts used for testing 
  include Contexts::Domains
  include Contexts::Users
  include Contexts::Projects
  include Contexts::Assignments
  include Contexts::Tasks
end