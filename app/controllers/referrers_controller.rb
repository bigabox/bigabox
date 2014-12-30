class ReferrersController < ApplicationController
    def user
         if(session[:user_id] == nil)    
              @ref_user = ReferralCode.find(:first, :conditions => ['code=?', params[:id]])
              if @ref_user
                  
                  @ref_user[:site_count] = @ref_user[:site_count]+1
                  @ref_user.save
                  
                  session[:ref_id] = @ref_user[:user_id]
                  session[:ref_code_id] = @ref_user[:id]
                  
              end
              redirect_to :controller => 'home', :action => 'sign_up'
          else
              redirect_to :controller => 'home', :action => 'index'
          end            
    end
end
