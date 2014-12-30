class CancelOrdersController < ApplicationController
    before_filter :authorize
     
    def index
        @meta_title = I18n.t 'meta_title.can_or'
        @user = User.find(session[:user_id])
        @site = SiteSetting.find(:first)
        @cancels_pending = CancelOrder.find(:all, :conditions => ['with_con=0 AND user_id=?', @user[:id]])
        @cancels_paid = CancelOrder.find(:all, :conditions => ['with_con=1 AND user_id=?', @user[:id]])
    end
    
    
end    