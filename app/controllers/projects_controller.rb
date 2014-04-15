class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  before_action :check_login
  authorize_resource

  def index
    @current_projects = Project.current.alphabetical.paginate(page: params[:page]).per_page(7)
    @past_projects = Project.past.alphabetical
  end

  def show
    authorize! :read, @project
    @project_tasks = @project.tasks.chronological.by_priority.paginate(page: params[:page]).per_page(10)
    @project_assignments = @project.assignments.by_user.paginate(page: params[:page]).per_page(8)
  end

  def new
    @project = Project.new
    task = @project.tasks.build
  end

  def edit
    # if shortcut access via projects#index
    if !params[:status].nil? && params[:status] == 'end'
      # @project.update_attribute(:end_date, Date.today)
      @project.end_project_now
      flash[:notice] = "#{@project.name} was ended as of today."
      redirect_to projects_path
    end
    # else prepare the dates for display
    @project.start_date = humanize_date @project.start_date
    @project.end_date = humanize_date @project.end_date
    
  end

  def create
    @project = Project.new(project_params)
    @project.manager_id = current_user.id  # set the manager to the user who created the project

    if @project.save
      # if saved to database
      flash[:notice] = "#{@project.name} has been created."
      redirect_to @project # go to show project page
    else
      # return to the 'new' form
      render :action => 'new'
    end
  end

  def update    
    if @project.update(project_params)
      flash[:notice] = "#{@project.name} has been updated."
      redirect_to @project
    else
      render :action => 'edit'
    end
  end

  def destroy
    status = @project.destroy
    if status
      flash[:notice] = "Successfully removed #{@project.name} from Arbeit."
    else
      flash[:error] = "#{@project.name} could not be deleted because of completed tasks, but has been ended as of today."
    end
    redirect_to projects_url
  end

  private
    def convert_start_and_end_dates
      params[:project][:start_date] = convert_to_date(params[:project][:start_date]) unless params[:project][:start_date].blank?
      params[:project][:end_date] = convert_to_date(params[:project][:end_date]) unless params[:project][:end_date].blank?
    end

    def set_project
      @project = Project.find(params[:id])
    end

    def project_params
      convert_start_and_end_dates
      params.require(:project).permit(:name, :description, :start_date, :end_date, :domain_id, :manager_id, tasks_attributes: [:name, :due_string, :priority])  
    end
end
