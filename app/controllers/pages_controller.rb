class PagesController < ApplicationController
  def index
      @page = Page.find(:first, :conditions => ['slug=? ', params[:id]])
      if @page
          @meta_title = @page[:pages_title]
      end
  end
end