class DomainsController < ApplicationController
  before_action :set_domain, only: [:show, :edit, :update, :destroy]
  before_action :check_login

  def index
    @domains = Domain.active.alphabetical.paginate(:page => params[:page]).per_page(10)
    @inactive_domains = Domain.inactive.alphabetical.to_a
  end

  def show
  end

  def new
    @domain = Domain.new
  end

  def edit
  end

  def create
    @domain = Domain.new(domain_params)
    if @domain.save
      # if saved to database
      flash[:notice] = "#{@domain.name} has been created."
      redirect_to @domain # go to show domain page
    else
      # return to the 'new' form
      render :action => 'new'
    end
  end

  def update
    if @domain.update_attributes(domain_params)
      flash[:notice] = "#{@domain.name} is updated."
      redirect_to @domain
    else
      render :action => 'edit'
    end
  end

  def destroy
    @domain.destroy
    flash[:notice] = "Successfully removed #{@domain.name} from Arbeit."
    redirect_to domains_url
  end

  private
    def set_domain
      @domain = Domain.find(params[:id])
    end

    def domain_params
      params.require(:domain).permit(:name, :active)  
    end
end
