class Assignment < ActiveRecord::Base
  include ArbeitHelpers

  # Relationships
  belongs_to :user
  belongs_to :project
  
  # Scopes
  scope :active, -> { where('assignments.active = ?', true) }
  scope :inactive, -> { where('assignments.active = ?', false) }
  scope :for_project, ->(project_id) { where('project_id = ?', project_id) }
  scope :for_user,    ->(user_id) { where('user_id = ?', user_id) }
  scope :by_user,     -> { joins(:user).order('users.last_name, users.first_name') }
  scope :by_project,  -> { joins(:project).order('projects.name') }
  
  # Validations
  validate :user_is_active_in_system
  validate :project_is_current_in_system, on: :create
  
  # Other methods
  def make_inactive
    self.active = false
    self.save!
  end

  def make_active
    self.active = true
    self.save!
  end
  
  private
  def user_is_active_in_system
    is_active_in_system(:user)
  end
  
  def project_is_current_in_system
    all_current_projects = Project.current.to_a.map{|p| p.id}
    unless all_current_projects.include?(self.project_id)
      errors.add(:project_id, "is not a current project in the system")
    end
  end  
end