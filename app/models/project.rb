class Project < ActiveRecord::Base
  
  # Relationships
  has_many :tasks
  has_many :assignments
  has_many :users, through: :assignments
  belongs_to :domain
  belongs_to :manager, class_name: "User", foreign_key: "manager_id"
  
  # allow tasks to be nested within project
  accepts_nested_attributes_for :tasks, reject_if: ->(task) { task[:name].blank? }, allow_destroy: true
  
  # Scopes
  scope :alphabetical, -> { order("name") }
  scope :current,      -> { where("start_date <= ? and (end_date > ? or end_date is null)", Date.today, Date.today) }
  scope :past,         -> { where("end_date <= ?", Date.today) }
  scope :for_name,     ->(name) { where("name LIKE ?", name + "%") }
  
  # Validations
  validates_presence_of :name
  validates_date :start_date
  validates_date :end_date, after: :start_date, allow_blank: true
  validate :domain_is_active_in_system
    
  # Callbacks
  before_destroy :is_destroyable?
  after_rollback :end_project_now

  def is_destroyable?
    self.tasks.completed.empty?
  end
  
  def end_project_now
    remove_incomplete_tasks
    set_all_assignments_to_inactive
    set_project_end_date_to_today
  end
  
  # Other methods
  def is_active?
    return true if end_date.nil?
    (start_date <= Date.today) && (end_date > Date.today)
  end
  
  private
  def domain_is_active_in_system
    all_active_domains = Domain.active.to_a.map{|d| d.id}
    unless all_active_domains.include?(self.domain_id)
      errors.add(:domain_id, "is not an active domain in the system")
    end
  end

  def remove_incomplete_tasks
    self.tasks.incomplete.each{ |t| t.destroy }
  end

  def set_all_assignments_to_inactive
    self.assignments.active.each{ |a| a.make_inactive }
  end

  def set_project_end_date_to_today
    self.end_date = Date.today
    self.save!
  end
end
