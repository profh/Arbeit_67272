class ErrorsController < ApplicationController
  # use minimal layout for cylon template...
  layout "bare", only: ["cylon"]
  
  def cylon
  end

  def not_found
  end
  
  def internal_error
  end
  
  def routing
    unless params[:a].nil?
      logger.info "500 Error with: '#{params[:a]}'"
    end
    render :action => "internal_error"
  end
  
end