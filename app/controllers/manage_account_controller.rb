class ManageAccountController < ApplicationController
    before_filter :authorize, :except => [:close_page, :confirm_user_account]
     
    def index
        @meta_title = I18n.t 'meta_title.manage_account'
        @user = User.find(session[:user_id])
        @site = SiteSetting.find(:first)
        @user_address = UserAddress.user_address(session[:user_id])
        
    end
    
    
    
   ######  contact info **************** 
   def save_email
        
        if request.post?
              
               @user = User.find(session[:user_id])
               @site = SiteSetting.find(:first)
               @user_address = UserAddress.user_address(session[:user_id]) 
               user = User.authenticate_by_pass(params[:user][:password], session[:user_id])
             
               if user  
                   respond_to do |format|
                          email = @user[:email]
                          params[:user][:email] = params[:user][:new_email] 
                         
                         if @user.update_attributes(params[:user])
                              
                              if @site[:verify_account]==1
                                   
                                   @user[:email] = email
                                   @num1 = 'forgot_'+SecureRandom.hex(10)
                                   @user[:forgot_unique_code] = @num1
                                   @user.save
                                    
                                   UserMailer.verify_email_change(@user).deliver
                                  
                                  session[:user_id] = nil
                                  session[:user_email] = nil
                                  flash[:notice1] = I18n.t 'manage_account_controller.verification_email_sent_new_email_address'
                                  format.html { redirect_to(:controller => 'home', :action=>'index' ) }
                              else
                                  UserMailer.change_email_notification(@user, email).deliver
                                  UserMailer.change_email_notification(@user, @user[:email]).deliver
                                  
                                  session[:user_email] = @user[:email]
                                  flash[:notice1] = I18n.t 'manage_account_controller.your_email_id_has_been_saved'
                                  format.html { redirect_to(:action=>'index' ) }
                              end           
                              
                              format.xml  { render :xml => @user, :status => :created, :location => @user }
                        else
                              @user[:email] = email
                              format.html { render :action => "index" }
                              format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
                        end
                    end
                     
                else
                         
                         flash[:notice] = I18n.t 'manage_account_controller.your_pwd_doesnot_match_records_email_changed'
                         redirect_to(:action=>'index' )
                end
                      
        end 
   end 
   
   
   def confirm_user_account
     @user =  User.find(:first, :conditions =>  ["forgot_unique_code = ? ", params[:id]])   
      if @user    
          
          email = @user[:email]
          @user[:email] = @user[:new_email]
          @user[:new_email] = ''
          @user[:forgot_unique_code] = ''
          @user.save
          
          session[:user_id] = @user[:id]
          session[:user_email] = @user[:email]
            
          UserMailer.change_email_notification(@user, email).deliver
          UserMailer.change_email_notification(@user, @user[:email]).deliver
          
          session[:user_email] = @user[:email]
          flash[:notice1] = I18n.t 'manage_account_controller.your_email_id_has_been_saved'
          redirect_to(:action=>'index' ) 
           
      else
           flash[:notice] = I18n.t 'manage_account_controller.email_change_request_does_not_exists_try_again'
           redirect_to(:controller => 'home', :action=>'index' ) 
      end
      
   end
   
   
   def save_address
      
        if request.post?
              
               @user = User.find(session[:user_id])
               @site = SiteSetting.find(:first)
               @user_address = UserAddress.user_address(session[:user_id]) 
              
                   respond_to do |format|
                   
                       if @user_address.update_attributes(params[:user_address]) 
                                           
                             User.update_all(["prefix = ? , first_name = ?, last_name = ?, suffix = ?, home_phone = ?, cell_phone = ? ", params[:user][:prefix], params[:user][:first_name], params[:user][:last_name], params[:user][:suffix], params[:user][:home_phone], params[:user][:cell_phone]], ["id = ?", @user[:id]])
                       
                             
                              flash[:notice1] = I18n.t 'manage_account_controller.your_details_saved_successfully'
                              format.html { redirect_to(:action=>'index' ) }
                          
                               format.xml  { render :xml => @user, :status => :created, :location => @user }
                        else
                          
                          format.html { render :action => "index" }
                          format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
                        end
                    end
         end 
   end
  
  
  ########## contact info ends ********************
  
  ######   password *****************
  
  def password
     @meta_title = I18n.t 'meta_title.change_password'
        if request.post?
              
               @user = User.find(session[:user_id])
               
               user = User.authenticate_by_pass(params[:old_password], session[:user_id])
             
               if user  
                   respond_to do |format|
                   
                         if @user.update_attributes(params[:user])
                                           
                              flash[:notice1] = I18n.t 'manage_account_controller.your_pwd_updated_successfully'
                              format.html { redirect_to(:action=>'password' ) }
                          
                               format.xml  { render :xml => @user, :status => :created, :location => @user }
                        else
                          
                          format.html { render :action => "password" }
                          format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
                        end
                    end
                     
                else
                         flash[:notice] = I18n.t 'manage_account_controller.old_pwd_entered_wrong_pwd_not_changed'
                         redirect_to(:action=>'password' )
                end
                      
        end 
         @user = User.find(session[:user_id])
  end
  
  ########### password ends ***************
    
  ########## credit card ******************  
  def credit_card
      @meta_title = I18n.t 'meta_title.credit_cards'
      @user = User.find(session[:user_id])
  end
    
  ############ credit card ends *********
  
     
  ########## Charges and Credits ******************  
  def charges
      @meta_title = I18n.t 'meta_title.charges_credits'
      @user = User.find(session[:user_id])
  end
    
  ############ Charges and Credits ends *********
  
  ###########  invoices ****************
  def invoices
    @meta_title = I18n.t 'meta_title.m_invoices'
    @user = User.find(session[:user_id])
  end
  ########## invoices ends ************
  
  
  ###########  email preferences ****************
  def emails
    @meta_title = I18n.t 'meta_title.m_email_preferences'
    @user = User.find(session[:user_id])
    @site = SiteSetting.find(:first)
    @emails = EmailPreference.user_email(session[:user_id])
     if request.post?
            respond_to do |format|
                 if @emails.update_attributes(params[:email_preference])
                                   
                      flash[:notice1] = I18n.t 'manage_account_controller.your_email_preferences_update_successfully'
                      format.html { redirect_to(:action=>'emails' ) }
                  
                      format.xml  { render :xml => @user, :status => :created, :location => @user }
                else
                  
                  format.html { render :action => "emails" }
                  format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
                end
            end
      end 
  end
  ########## email preferences ends ************
 
 ########## Payment accounts ************ 
  def payaccounts
      @meta_title = I18n.t 'meta_title.m_payment_accounts'
    @user = User.find(session[:user_id])
    @event = Event.find_all_events(session[:user_id])
    #render :text => params.inspect and return
    
    
     if request.post?
          respond_to do |format|
               if params[:type]!=''                 
                  User.update_all(["event_pay_account = ? ,ref_pay_account = ?", params[:event_pay_account],params[:ref_pay_account]], ["id = ?", @user[:id]])
               end
               
               if params[:bank_name]!=''
                 
                  @user_bank = UserBankDetail.find(:first, :conditions => ['user_id=?', @user[:id]])
                  if @user_bank
                    UserBankDetail.update_all(["bank_name = ? , bank_branch = ?, bank_ifsc_code = ?", params[:bank_name],params[:bank_branch], params[:bank_ifsc_code]], ["user_id = ?", @user[:id]])
                  else
                    @user_bank = UserBankDetail.new
                    @user_bank[:user_id] = @user[:id]
                    @user_bank[:bank_name] = params[:bank_name]
                    @user_bank[:bank_branch] = params[:bank_branch]
                    @user_bank[:bank_ifsc_code] = params[:bank_ifsc_code]
                    @user_bank.save
                  end
               end  
               
               flash[:notice1] = I18n.t 'manage_account_controller.your_paypal_email_update_successfully'         
               format.html { redirect_to(:action=>'payaccounts' ) }
          
               format.xml  { render :xml => @user, :status => :created, :location => @user }
          end
      end  
  end
  
 ########## Payment accounts ends ************
  
  ###########  Multi User Access ****************
def multi_users
    @meta_title = I18n.t 'meta_title.multi_user_access'
    @user = User.find(session[:user_id])
    @permittted_users = Permission.permitted_users(session[:user_id])
   
    
    if request.post?
      
            respond_to do |format|
                  @num1 = 'forgot_'+SecureRandom.hex(10)
                  date1 = DateTime.now
                  @site = SiteSetting.find(:first)
                  n = @site[:forgot_time_limit]
                  date1 = (date1.to_time + n.hours).to_datetime
                  
                  params[:user][:forgot_unique_code] = @num1
                  params[:user][:request_date] = date1
                  params[:user][:user_api_key] = SecureRandom.hex(15)
                  params[:user][:ref_id] = session[:user_id]
                  params[:user][:user_ip] = request.remote_ip
                   
                 @new_user = User.new(params[:user])
                 if @new_user.save
                       UserMailer.multi_user_access(@new_user, @user).deliver
                       params[:permission][:user_id] = @new_user[:id]
                                              
                       if(params[:permission][:event]=='select')
                          if params[:event]
                            params[:permission][:event]= params[:event].join(',')
                          end
                       end
                       
                       if(params[:permission][:action]=='select')
                          if params[:action1]
                            #render :text=> params[:action1].inspect and return
                            params[:permission][:action]= params[:action1].join(',')
                          end  
                       end
                       
                       if(params[:permission][:email]=='select')
                          if params[:email1]
                            params[:permission][:email]= params[:email1].join(',')
                          end  
                       end
                           
                       @permission = Permission.new(params[:permission])
                       @permission.save
                                   
                      flash[:notice1] = I18n.t 'manage_account_controller.new_multi_user_account_has_been_created_login_instructions_sent_address_provided'
                      format.html { redirect_to(:action=>'multi_users' ) }
                  
                      format.xml  { render :xml => @new_user, :status => :created, :location => @new_user }
                else
                  
                  format.html { render :action => "multi_users" }
                  format.xml  { render :xml => @new_user.errors, :status => :unprocessable_entity }
                end
            end
      end 
  end  
  
  
  def edit_multi_user
    
     if request.post?
#     render :text => params[:permission][:action] and return
            @permission = Permission.find(params[:permission][:id])     
             if(params[:permission][:event]=='select')
                params[:permission][:event]= params[:event].join(',')
             end
             
             if(params[:permission][:action]=='select')
                params[:permission][:action]= params[:action1].join(',')
             end
             
             if(params[:permission][:email]=='select')
                params[:permission][:email]= params[:email1].join(',')
             end
              
              
            respond_to do |format|
                Permission.update_all(["event = ? , action = ?, email=? ",  params[:permission][:event],  params[:permission][:action],  params[:permission][:email]], ["id = ?", params[:permission][:id]])
                flash[:notice1] = I18n.t 'manage_account_controller.your_user_permission_have_saved'
                format.html { redirect_to(:action=>'multi_users' ) }
            
                format.xml  { render :xml => @user, :status => :created, :location => @user }
            end
      end 
  end
  
  def add_user_form
      render :template => 'manage_account/_add_user_form', :layout => false
  end
  ########## Multi User Access ends ************  
  
  ########## Unused Organizer ***********
  def unuse_org
    @meta_title = I18n.t 'meta_title.m_unused_org'
    @user = User.find(session[:user_id])
    @organizers = Organizer.unused_org(session[:user_id])
  end
  
  def delete_unused
    @org = Organizer.find(params[:id])
    @org.destroy
    
    flash[:notice1] = I18n.t 'manage_account_controller.org_account_deleted_successfully'
    redirect_to(:action=>'unuse_org' )
  end
  ########## Unused Organizer ends ***********
  
  ##########  Referral Program ***************
  
  def referral_program
      @meta_title = I18n.t 'meta_title.m_referral_program'
      @user = User.find(session[:user_id])
      @site = SiteSetting.find(:first)
      @referrals = ReferralCode.find(:all, :conditions => ['user_id=? ', session[:user_id]])
  end
  
  def save_ref_pay_account
     @user = User.find(session[:user_id])
     User.update_all([" ref_pay_account = ? ", params[:ref_pay_account]], ["id = ?", @user[:id]])
     render :text => (I18n.t 'manage_account_controller.user_account_updated_successfully')
    
  end
  
  def save_ref_unique_no
      @ref = ReferralCode.new
      @ref[:user_id] = session[:user_id]
      @ref[:code] = params[:unique_no]
      if @ref.save
          render :text => (I18n.t 'contact_controller.success')
      else
          render :text => @ref.errors.full_messages[0]  
      end    
  end
  ########## Referral Program ends **********
  
  #########  Affiliate Program starts *******
  def affiliates
      @meta_title = I18n.t 'meta_title.affiliate_programs'
      @user = User.find(session[:user_id])
      @site = SiteSetting.find(:first)
      @affiliates = UserJoin.find(:all, :conditions => ['user_id=? ', session[:user_id]])
  end
  
  
  
  ########  Affiliate Program Ends *********
  
  
  
  
  
  ########## API User Key ends **********
 
  def apikey
       @user = User.find(session[:user_id])
       @site = SiteSetting.find(:first)
  end
  
  def requestapi
      @user = User.find(session[:user_id])
      @site = SiteSetting.find(:first)
      @apikeys = ApiKey.find(:all, :conditions => ['user_id=? ', session[:user_id]])
      @apikey = ApiKey.new
      
       if request.post?
            respond_to do |format|
                
                params[:apikey][:api_key] =  SecureRandom.hex(20)
                params[:apikey][:status] =  (I18n.t 'manage_account_controller.approved')
                @apikey = ApiKey.new(params[:apikey])
                
                if @apikey.save
                    UserMailer.api_key_generated(@user, params[:apikey][:api_key]).deliver
                    flash[:notice1] = (I18n.t 'manage_account_controller.your_api_generated_successfully')
                    format.html { redirect_to(:action=>'requestapi' ) }
                
                    format.xml  { render :xml => @apikey, :status => :created, :location => @apikey }
                else
                   format.html { render :action => "requestapi" }
                   format.xml  { render :xml => @apikey.errors, :status => :unprocessable_entity }
                end      
            end
      end 
  end
  ########## API User Key ends **********
  ########## CLose account ***********
  def close_account
      @user = User.find(session[:user_id])
      @site = SiteSetting.find(:first)
      if request.post?
            user = User.authenticate_by_pass(params[:password], session[:user_id])
            if user 
                @user = User.find(session[:user_id])
                @user.destroy
                
                ### Email Preference UserId Delete Start ####
                
                @emailpref = EmailPreference.find(:first , :conditions => ['user_id=?', @user])
                @emailpref.destroy
                
                #### End #####
                
                ####### Contact List UserId Delete Start ########
                
                @contact_list = ContactList.find(:first , :conditions => ['user_id=?', @user])
                if @contact_list
                  @contact = Contact.find(:first , :conditions => ['contact_list_id=?', @contact_list[:id]])
                  if @contact
                    @contact.destroy
                  end
                  @contact_list.destroy
                end
                
                ####### End #######
                
                ######### User Address UserId Delete Start #######
                
                @user_address = UserAddress.find(:first , :conditions => ['user_id=?', @user])
                if @user_address
                  @user_address.destroy
                end
                
                ####### End ########
                
                ########### Save Event ######
                
                @save_event = SaveEvent.find(:first , :conditions => ['user_id=?', @user])
                if @save_event
                  @save_event.destroy
                end
                
                ####### End ##########
                
                session[:user_id]=nil
                session[:user_email]=''
               
                redirect_to(:action=>'close_page')
            else
                 flash[:notice] = (I18n.t 'manage_account_controller.invalid_pwd_try_again')
                 render :action=>'close_account'
            end
      end 
  end
  
  
  def close_page
  end
  ########## CLose account ends ***********
  
  def delete_user
    
    @user = User.find(params[:id])
    @user.destroy
    
    @permission = Permission.find(params[:per_id])
    @permission.destroy
    
     flash[:notice1] = (I18n.t 'manage_account_controller.user_account_deleted_successfully')
     redirect_to(:action=>'multi_users' )
  end
     
  def state_selection
       @state = State.find_state_by_country(params[:country_id])
       respond_to do |format|
         format.html  { render :layout => false }
       end 
  end
  
end