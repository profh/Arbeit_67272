class TasksController < ApplicationController
  # before_action :set_task, only: [:show, :edit, :update, :destroy, :ajax_complete, :ajax_incomplete, :complete, :incomplete]
  before_action :set_task, except: [:index, :new, :create, :convert_due_on, :task_params, :set_task]
  before_action :check_login
  # authorize_resource

  def index
    @pending_tasks = Task.incomplete.chronological.includes(:project).paginate(:page => params[:page]).per_page(7)
    authorize! :index, @pending_tasks
    @completed_tasks = Task.includes(:project).completed.by_completion_date.last(20)
    authorize! :index, @completed_tasks
  end

  def show
    authorize! :show, @task
  end

  def new
    @task = Task.new
    authorize! :new, @task
    @task.project_id = params[:project_id] unless params[:project_id].nil?
  end

  def edit
    authorize! :edit, @task
    # in case this is a quick complete...
    if !params[:status].nil? && params[:status] == 'completed'
      @task.completed = true
      @task.completed_by = current_user.id
      @task.save!
      flash[:notice] = "#{@task.name} has been marked complete."
      if params[:from] == 'project'
        redirect_to project_path(@task.project)
      else
        redirect_to tasks_path
      end
    end
  end

  def create
    @task = Task.new(task_params)
    authorize! :create, @task
    @task.created_by = current_user.id
    if @task.save
      # if saved to database
      respond_to do |format|
        format.html { redirect_to @task, notice: "#{@task.name} has been created." }
        @project_tasks = @task.project.tasks.chronological.by_priority.paginate(page: params[:page]).per_page(10)
        format.js
      end
    else
      # return to the 'new' form
      render :action => 'new'
    end
  end

  def update
    authorize! :update, @task
    params[:task].each { |attribute,value| @task[attribute] = value }
    @task.due_on = convert_to_datetime(params[:task][:due_on])
    @task.due_string = params[:task][:due_on]
    if params[:task][:completed] == "1"
      @task.completed_by = current_user.id
    else
      @task.completed_by = nil
    end
    if @task.save!
      flash[:notice] = "#{@task.name} is updated."
      redirect_to @task
    else
      render :action => 'edit'
    end
  end

  def destroy
    authorize! :destroy, @task
    @task.destroy
    flash[:notice] = "Successfully removed #{@task.name} from Arbeit."
    redirect_to tasks_url
  end

  def toggle
    if params[:status] == 'complete'
      @task.completed = true
      @task.completed_by = current_user.id
    else
      @task.completed = false
      @task.completed_by = nil
    end
    @task.save!
    @project_tasks = @task.project.tasks.chronological.by_priority.paginate(page: params[:page]).per_page(10)
  end

  
  # ===================================
  # Two new methods to handle changing completed field
  def complete
    # set completed and completed_by fields
    @task.completed = true
    @task.completed_by = current_user.id

    if @task.save!
      flash[:notice] = 'Task was marked as completed.'
      if params[:status] == "task_details"
        redirect_to task_path(@task)
      else
        redirect_to home_path
      end
    else
      render :action => "edit"
    end
  end

  def incomplete
    @task.completed = false
    @task.completed_by = nil

    if @task.save!
      flash[:notice] = 'Task was changed back to incomplete.'
      redirect_to task_path(@task)
    else
      render :action => "edit"
    end
  end

  private
    def convert_due_on
      params[:task][:due_on] = convert_to_date(params[:task][:due_on]) unless params[:task][:due_on].blank?
    end

    def set_task
      @task = Task.find(params[:id])
    end

    def task_params
      convert_due_on
      params.require(:task).permit(:name, :due_on, :due_string, :project_id, :completed, :completed_by, :created_by, :priority)  
    end
end
