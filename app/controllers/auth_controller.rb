class AuthController < ApplicationController  
  
  def facebook
     if(session[:user_id] == nil)        
               @user = User.new(:password => '123456789')
               @user[:first_name] = env["omniauth.auth"]["extra"]["raw_info"]["first_name"]
               @user[:last_name] = env["omniauth.auth"]["extra"]["raw_info"]["last_name"]
               @user[:email] = env["omniauth.auth"]["extra"]["raw_info"]["email"]
               @user[:fb_id] = env["omniauth.auth"]["extra"]["raw_info"]["id"]
               @user[:fb_access_token] = env["omniauth.auth"]["credentials"]["token"]
               @user[:user_ip] = request.remote_ip
                    
                
               @user_find = User.find(:first, :conditions => ['email=? ', @user[:email]])
               if @user_find
                 
                    # -- If user already exists, display twitter image in profile --#               
                   @org = Organizer.find(:first, :conditions => ['user_id=? ', @user_find[:id]])
                   @org[:fb_logo] = env["omniauth.auth"]["info"]["image"].gsub(/square/,'large') 
                   @org.save 
                   # -- End of Code --#
                                                  
                    @user_find[:fb_id] = @user[:fb_id]
                    @user_find[:fb_access_token] = @user[:fb_access_token]
                    
                    @user_find.save
                   
                   if @user_find[:active] == 1
                      session[:user_id] = @user_find[:id]
                      session[:user_email] = @user_find[:email]
                      session[:social_id] = "fb"

                     
                     if @user_find[:set_pass]==1
                        flash[:notice1] = I18n.t 'home_controller.you_logged_in_successfully'
                        redirect_to(:controller => 'home', :action => 'index') and return
                     end
                   else
                        flash[:notice] = I18n.t 'home_controller.your_account_inactivate'
                        redirect_to(:controller => 'home', :action => 'index') and return
                   end  
                    
               else
                
                 @user[:active]=1
                 @user.save
                 
                 #  -- Get gender from fb -- #
                 
                 if @user.save                 
                   @user_address = UserAddress.new(:user_id => @user[:id])
                   @user_address[:gender] = env["omniauth.auth"]["extra"]["raw_info"]["gender"].capitalize
                   @user_address.save      
                   
                   # -- End gender code -- #
                   # -- Get Name and Profile pic from FB (Code during 1st time Login)-- #
                 
                   @organizer = Organizer.new(:user_id => @user[:id])
                   
                   @organizer[:fb_logo] = env["omniauth.auth"]["info"]["image"].gsub(/square/,'large') 
                   @organizer[:name]  =  env["omniauth.auth"]["extra"]["raw_info"]["name"]     
                   @organizer[:is_user] = 1
                   @organizer.save 
                   
                  # -- End of Code -- #
                 end
                  
                 session[:user_id] = @user[:id]
                 session[:user_email] = @user[:email]
                 session[:social_id] = "fb"
      
               end
               render :layout => 'home', :template => 'home/facebook_login'
         
     else
         redirect_to(:controller => 'home', :action => 'index') and return
     end      
  end
  
  def callback_error
     if params[:error_message]!='' && params[:error_message]!=nil
        flash[:notice] = params[:error_message]
     else
        flash[:notice] = I18n.t 'home_controller.something_wrong_yor_facebook_amount_try_again'
     end  
     #render :text => params
     redirect_to(:controller => 'home', :action => 'index')
  end
  
  def failure
     flash[:notice] = I18n.t 'home_controller.something_wrong_yor_facebook_amount_try_again'
     redirect_to :controller => 'home', :action => 'login'
  end
  
  
  def twitter
     if(session[:user_id] == nil)  
       
        auth = request.env["omniauth.auth"]
        @user = User.new(:password => '123456789')
       
        @user[:tw_oauth_token] = auth['credentials']['token']
        @user[:tw_oauth_secret] = auth['credentials']['secret']
        @user[:tw_screen_name] = auth['extra']['raw_info']['screen_name']
        @user[:tw_id] = auth['extra']['raw_info']['id'] 
        @user[:user_ip] = request.remote_ip
        
        @name = auth['info']['name']
        @split_name = @name.split(' ')
        @user[:first_name] = @split_name[0]
        @user[:last_name] = @split_name[1]
        
         @user_find = User.find(:first, :conditions => ['tw_id=? ', @user[:tw_id]])
         if @user_find
           
               # -- If user already exists, display twitter image in profile -- #
               @org = Organizer.find(:first, :conditions => ['user_id=? ', @user_find[:id]])
               @org[:tw_logo] = auth['info']['image'].gsub("_normal", "_400x400")                 
               @org.save
               
               # -- End Code --# 
                                  
              @user_find[:tw_oauth_token] = @user[:tw_oauth_token]
              @user_find[:tw_oauth_secret] = @user[:tw_oauth_secret]
              @user_find[:tw_screen_name] = @user[:tw_screen_name]
              @user_find[:tw_id] = @user[:tw_id]
              
              @user_find.save
             
             if @user_find[:active] == 1
                session[:user_id] = @user_find[:id]
                session[:user_email] = @user_find[:email]
                session[:social_id] = "tw"
               
               if @user_find[:set_pass]==1
                  flash[:notice1] = I18n.t 'home_controller.you_logged_in_successfully'
                  redirect_to(:controller => 'home', :action => 'index') and return
               end
             else
                  flash[:notice] = I18n.t 'home_controller.your_account_inactivate'
                  redirect_to(:controller => 'home', :action => 'index') and return
             end  
              
         else
          
           @user[:active]=1
           @user.save
           
            # -- Get Name and Profile pic from Twitter (Code during 1st time Login)-- #
           if @user.save
             @organizer = Organizer.new(:user_id => @user[:id])
             @organizer[:tw_logo] = auth['info']['image'].gsub("_normal", "_400x400")  
             @organizer[:name]  =  auth['info']['name'] 
             @organizer[:is_user] = 1
             @organizer.save 
           end
           
           # -- End of code -- #
           
           session[:user_id] = @user[:id]
           session[:social_id] = "fb"
           
         end
         
         render :layout => 'home', :template => 'home/facebook_login'
     else
         @user = User.find(session[:user_id])
         if @user[:set_pass]==1
            redirect_to(:controller => 'home', :action => 'index') and return
         else
           render :layout => 'home', :template => 'home/facebook_login'
         end     
     end       
        
  end
  
end