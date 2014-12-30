class HomeController < ApplicationController
  before_filter :authorize, :except => [:login, :sign_up, :index, :forgot_password, :set_new_password, :confirm_user_account, :social_password, :contact_us, :logout]
 
  
  def index
    #render :layout => 'home', :template => 'home/index'
  end
  
  def sign_up
     @meta_title = I18n.t 'meta_title.meta_sign_up'
     @type = 'sign'
     
     if(session[:user_id] == nil)    
          if request.post?
              
              params[:user][:user_api_key] = SecureRandom.hex(18)
              params[:user][:set_pass] = 1
              params[:user][:user_ip] = request.remote_ip
              
              @user = User.new(params[:user])
              respond_to do |format|
                
                if @user.save
                  
                    if(params[:remember]=='1')
                        cookies[:eventbrite_user_id] = { :value => @user[:id],:expires => 1.month.from_now}
                        cookies[:eventbrite_passw] = { :value => params[:user][:password],  :expires => 1.month.from_now}
                    end
                    @site = SiteSetting.find(:first)
                    if @site[:verify_account]==1
                         
                         @num1 = 'forgot_'+SecureRandom.hex(10)
                         @user[:forgot_unique_code] = @num1
                         @user[:active]=0
                         @user.save
                          
                         UserMailer.verify_account_email(@user).deliver
                        
                         flash[:notice1] = I18n.t 'home_controller.home_js'
                         format.html  { redirect_to :action => 'index' }
                    else
                        
                        UserMailer.welcome_email(@user).deliver
                        session[:user_id] = @user[:id]
                        session[:user_email] = @user[:email]
                        
                        @refnum = 'refer'+SecureRandom.hex(25)
                        @ref = ReferralCode.new
                        @ref[:user_id] = @user[:id]
                        @ref[:code] = @refnum
                        @ref.save
                    
                    
                        @site = SiteSetting.find(:first)
                        if session[:ref_id]!='' && session[:ref_id]!=nil
                            @user[:ref_id] = session[:ref_id]
                            @user[:ref_code_id] = session[:ref_code_id]
                            @user.save
                            
                           
                            @ref_code = ReferralCode.find(session[:ref_code_id])
                            @ref_code[:sign_up] = @ref_code[:sign_up]+1
                            @ref_code[:revenue_generated] = @ref_code[:revenue_generated]+@site[:ref_comm_amt]
                            @ref_code.save
                            
                            if @site[:ref_comm_amt] > 0
                               @wallet_ref = Wallet.new
                               @wallet_ref[:credit] = @site[:ref_comm_amt]
                               @wallet_ref[:user_id] = session[:ref_id]
                               @wallet_ref[:ref_id] = @ref_code[:id]
                               @wallet_ref.save
                           end
                            
                            session[:ref_id] = ''
                            session[:ref_code_id] = ''
                        end
                        
                        if session[:affiliate_id]!='' && session[:affiliate_id]!=nil
                                @join = UserJoin.new
                                @join[:user_id] = session[:user_id]
                                @join[:affiliate_id] = session[:affiliate_id]
                                @join.save
                                
                                @aff = Affiliate.find(session[:affiliate_id])
                                Affiliate.update_all(["affiliates = ?", @aff[:affiliates]+1], ["id = ?", @aff[:id]])
                                session[:affiliate_id]=''
                                flash[:notice] = (I18n.t 'home_controller.you_join_successfully')
                               format.html { redirect_to :controller => 'manage_account', :action => 'affiliates' }
                        else
                                        
                            flash[:notice1] = I18n.t 'home_controller.you_register_logged'
                           
                             
                             
                            if session[:return_to]!='' && session[:return_to]!=nil
                                path = session[:return_to]
                                session[:return_to] = ''
                               format.html { redirect_to(path) } 
                            else
                               format.html { redirect_to :action => 'index' }
                            end 
                       end 
                    end
                      
                else
                  format.html { render :action => "sign_up", :template => 'home/login' }
                  format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
                end
              end        
          else
             @user = User.new(params[:user])
             render :template => 'home/login'
          end
          
       else
           redirect_to :action => 'index'
       end   
  end
  
 
  def login
      @meta_title = I18n.t 'meta_title.meta_login'
      @user = User.new()
      @type = 'login'
      
      
      #if params[:ret]=='yes'
      #      session[:return_to] = session[:return_url_event]
      #      session[:return_url_event] = nil
      #end
       
      if(session[:user_id] == nil)        
     
            if request.post?
                  user = User.authenticate(params[:user_email], params[:user_password])
                  if user
                    if user.active == 1
                        session[:user_id] = user.id
                        session[:user_email] = user.email
                          
                            if(params[:remember]=='1') then
                               cookies[:eventbrite_user_id] = { :value => user.id,:expires => 1.month.from_now}
                                cookies[:eventbrite_usrpass] = { :value => params[:user_password],:expires => 1.month.from_now}
                            end
                                        
                          
                          if session[:affiliate_id]!='' && session[:affiliate_id]!=nil
                             @join = UserJoin.find(:first, :conditions => ['user_id=? and affiliate_id=?', session[:user_id], session[:affiliate_id]])
                             @aff = Affiliate.find(session[:affiliate_id])
                             
                             if @aff[:user_id]!=session[:user_id]
                               if @join
                                  flash[:notice] = I18n.t 'notice.already_join'
                                  redirect_to :controller => 'manage_account', :action => 'affiliates'
                                else
                                    @join = UserJoin.new
                                    @join[:user_id] = session[:user_id]
                                    @join[:affiliate_id] = @aff[:affiliate_id]
                                    @join.save
                                   
                                    Affiliate.update_all(["affiliates = ?", @aff[:affiliates]+1], ["id = ?", @aff[:id]])
                                    session[:affiliate_id]=''
                                    flash[:notice] = I18n.t 'home_controller.you_join_successfully'
                                    redirect_to :controller => 'manage_account', :action => 'affiliates'
                                end
                             else
                                  redirect_to :controller => 'affiliates', :action => 'join/'+@aff[:name]
                             end 
                              
                          else
                              flash[:notice1] = I18n.t 'home_controller.you_logged_in_successfully'
                              
                             
                             
                              if session[:return_to]!='' && session[:return_to]!=nil
                                  path = session[:return_to]
                                  session[:return_to] = ''
                                  redirect_to(path)
                              else
                                  redirect_to :action => 'index'
                              end  
                         end       
                    else
                        flash.now[:notice] = I18n.t 'home_controller.your_account_inactivate'
                    end        
                  else
                     
                      flash.now[:notice] = I18n.t 'home_controller.invalid_user_pwd_combination'
                  end
            end
       else
           redirect_to :action => 'index'
       end        
  end
   
  
  
  def social_password
     if(session[:user_id] == nil || session[:user_id]=='') 
        redirect_to :action => 'login'
     else
         
      if User.exists?(session[:user_id])
          @user = User.find(session[:user_id])
          if request.post?
             
              @user_find = User.find(:first, :conditions => ['email=? ', params[:user][:email]])
               if @user_find && @user_find[:id]!=@user[:id]
                  @user_find[:tw_oauth_token] = @user[:tw_oauth_token]
                  @user_find[:tw_oauth_secret] = @user[:tw_oauth_secret]
                  @user_find[:tw_screen_name] = @user[:tw_screen_name]
                  @user_find[:tw_id] = @user[:tw_id]
                  
                  @user_find[:user_ip] = @user[:user_ip] 
                  @user_find[:first_name] = params[:user][:first_name]
                  @user_find[:last_name] = params[:user][:last_name]
                  @user_find[:set_pass] = params[:user][:set_pass]
                  @user_find.save
                  
                  @user.destroy
                 if @user_find[:active] == 1
                    session[:user_id] = @user_find[:id]
                    session[:user_email] = @user_find[:email]
                    
                    #flash[:notice1] = I18n.t 'home_controller.you_logged_in_successfully'
                    flash[:notice1] = I18n.t 'home_controller.email_exists_update_info'

                    redirect_to :action => 'index'
                 else
                     session[:user_id] = nil
                     session[:user_email] = nil
                    
                      flash[:notice] = I18n.t 'home_controller.your_account_inactivate'
                      redirect_to(:controller => 'home', :action => 'index') and return
                 end  
              else
                  @user.update_attributes(params[:user])
                  
                 # Add gender information
                   
                 if  @user.update_attributes(params[:user])                     
  			if @user[:tw_id]!='' && @user[:tw_id]!=nil
                    @user_address = UserAddress.new(:user_id => session[:user_id])                    
                    @user_address[:gender] = params[:user_address][:gender]
                    @user_address.save
                    
                  end  
                 end
                    
                 # End of add gender to table
                  
                  session[:user_email] = params[:user][:email]
                  UserMailer.welcome_email(@user).deliver
                  
                 # flash[:notice1] = 'Email id already exists.logged in successfully'
                  flash[:notice1] = I18n.t 'home_controller.you_logged_in_successfully'
                   
                 #redirect_to :action => 'index'
                  if session[:return_to]!='' && session[:return_to]!=nil
                      path = session[:return_to]
                      session[:return_to] = ''
                      redirect_to(path)
                  else
                      redirect_to :action => 'index'
                  end 
              end     
          else
            render :template => 'home/facebook_login'   
          end##post else end
      else
          session[:user_id] = nil
          session[:user_email] = nil
         
          redirect_to(:action=>'index' )
      end####if user ends   
    end  
  end
  
  
  def forgot_password
     @meta_title = I18n.t 'meta_title.forgot_pwd'
    if(session[:user_id] == nil)        
            
            if request.post?
                  email = params[:user_email]
                  @user =  User.find(:first, :conditions =>  ["email = ? ", email])
                  if @user
                        @num1 = 'forgot_'+SecureRandom.hex(10)
                        date1 = DateTime.now
                        @site = SiteSetting.find(:first)
                        n = @site[:forgot_time_limit]
                        date1 = (date1.to_time + n.hours).to_datetime
                        
                       User.update_all(["forgot_unique_code = ? , request_date = ?", @num1, date1.strftime('%Y-%m-%d %H:%M:%S')], ["id = ?", @user[:id]])
                       
                       UserMailer.forgot_passwprd_email(@user[:id]).deliver
                      
                       flash[:notice1] = I18n.t 'home_controller.we_send_email_instructions'
                       redirect_to(:action=>'index' )
                  else
                      flash.now[:notice] = I18n.t 'home_controller.invalid_email_address'
                  end
            end
       else
           redirect_to :action => 'index'
       end  
  end
  
 
 def confirm_user_account
    if(session[:user_id] == nil)        
          
            @user =  User.find(:first, :conditions =>  ["forgot_unique_code = ? ", params[:id]])   
            if @user    
                 @user[:active]=1
                 @user[:forgot_unique_code]=''
                 @user.save
                
                  UserMailer.welcome_email(@user).deliver
                  session[:user_id] = @user[:id]
                  session[:user_email] = @user[:email]
                  
                  @refnum = 'refer'+SecureRandom.hex(25)
                  @ref = ReferralCode.new
                  @ref[:user_id] = @user[:id]
                  @ref[:code] = @refnum
                  @ref.save
              
              
                  @site = SiteSetting.find(:first)
                  if session[:ref_id]!='' && session[:ref_id]!=nil
                      @user[:ref_id] = session[:ref_id]
                      @user[:ref_code_id] = session[:ref_code_id]
                      @user.save
                      
                     
                      @ref_code = ReferralCode.find(session[:ref_code_id])
                      @ref_code[:sign_up] = @ref_code[:sign_up]+1
                      @ref_code[:revenue_generated] = @ref_code[:revenue_generated]+@site[:ref_comm_amt]
                      @ref_code.save
                      
                      if @site[:ref_comm_amt] > 0
                         @wallet_ref = Wallet.new
                         @wallet_ref[:credit] = @site[:ref_comm_amt]
                         @wallet_ref[:user_id] = session[:ref_id]
                         @wallet_ref[:ref_id] = @ref_code[:id]
                         @wallet_ref.save
                     end
                      
                      session[:ref_id] = ''
                      session[:ref_code_id] = ''
                  end
                  
                  if session[:affiliate_id]!='' && session[:affiliate_id]!=nil
                          @join = UserJoin.new
                          @join[:user_id] = session[:user_id]
                          @join[:affiliate_id] = session[:affiliate_id]
                          @join.save
                          
                          @aff = Affiliate.find(session[:affiliate_id])
                          Affiliate.update_all(["affiliates = ?", @aff[:affiliates]+1], ["id = ?", @aff[:id]])
                          session[:affiliate_id]=''
                          flash[:notice] = I18n.t 'notice.success_join'
                         format.html { redirect_to :controller => 'manage_account', :action => 'affiliates' }
                  else
                                  
                      flash[:notice1] = I18n.t 'home_controller.your_account_activated'
                     
                      if session[:return_to]!='' && session[:return_to]!=nil
                          path = session[:return_to]
                          session[:return_to] = ''
                          redirect_to(path)  
                      else
                         redirect_to :action => 'index' 
                      end 
                 end 
            else
                 flash[:notice] = I18n.t 'home_controller.your_account_does_not_exists'
                 redirect_to(:action=>'index' ) 
            end
                  
     else
         redirect_to :action => 'index'
     end 
 end
 
 
  def set_new_password
     @meta_title = I18n.t 'meta_title.set_pwd'
       if(session[:user_id] == nil)        
              @user =  User.find(:first, :conditions =>  ["forgot_unique_code = ? ", params[:id]])   
              if @user    
                 
                  
                  if @user[:request_date] > DateTime.now
                          if request.post?
                              @user.update_attributes(params[:user])
                              session[:user_id] = @user[:id]
                              session[:user_email] = @user[:email]
                              flash[:notice1] = I18n.t 'home_controller.password_reset_successfully'
                              redirect_to(:action=>'index')
                          end
                  else
                         flash[:notice] = I18n.t 'home_controller.your_pwd_time_limit_expired'
                         redirect_to(:action=>'index' )
                  end  
                  
              else
                       flash[:notice] = I18n.t 'home_controller.your_pwd_recovery_does_not_exists'
                       redirect_to(:action=>'index' )
              end      
       else
           redirect_to :action => 'index'
       end  
  end
   
  
  def contact_us
      @meta_title = I18n.t 'meta_title.contact_us'
      @site = SiteSetting.find(:first)
      if session[:user_id]!='' && session[:user_id]!=nil
        @user = User.find(session[:user_id])
      else
        @user = User.new
      end    
       if request.post?
           respond_to do |format|
                @con = AdminContact.new(params[:con])
                UserMailer.contact_us_email(@con).deliver 
                if @con.save
                    flash[:notice1] = I18n.t 'home_controller.your_que_send_successfully_admin_contact'
                    format.html { redirect_to :action => 'contact_us' }
                end 
           end
       end
  end
  
  def logout
    session[:user_id] = nil
    session[:user_email] = nil
    session[:event_password] = nil
    flash[:notice1] = I18n.t 'home_controller.you_logged_out_successfully'
    #render :text => 'test'
    redirect_to(:action=>'index' )
  end
   
  private
  def redirect_to_index(msg = nil)
    flash[:notice] = msg
    redirect_to :action => 'index'
  end
  
  def after_signup(user)
       
  end
  
end