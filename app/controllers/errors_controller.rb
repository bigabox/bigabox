class ErrorsController < ApplicationController
  def error_404
    @error_no = '404'
    render :layout => 'home'
  end

  def error_500
     @error_no = '500'
    render :layout => 'home'
  end
end
