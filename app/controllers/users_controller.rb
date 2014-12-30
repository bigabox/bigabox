class UsersController < ApplicationController
 before_filter :authorize
 include ApplicationHelper
 
  # GET /users
  # GET /users.json
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  
  def org
    @meta_title = I18n.t 'user_profile.add_new_org'
      @has_profile = has_action_rights('org_profile')
      if @has_profile != 0
         flash[:notice] = I18n.t 'event_controller.not_access_page'        
         redirect_to(:controller => 'home', :action=>'index' ) and return # else redirect to reffered events
      end
     
      #check if user is multi usr or regular
      @user = User.find(session[:user_id]) # multi user is not allowed to create any Org profiles
      if @user[:ref_id]!=nil && @user[:ref_id]!="" 
	 flash[:notice] = I18n.t 'event_controller.not_access_page'        
         redirect_to(:controller => 'home', :action=>'index' ) and return # else redirect to reffered events
      end
	      
  
     @user = User.find(session[:user_id])
     @organizers = Organizer.find(:all, :conditions => ['user_id=?', session[:user_id]])
     @org = Organizer.new
     @events = nil
     @site = SiteSetting.find(:first)
     render :template => 'users/profile'
  end
  
  def profile
     @meta_title = I18n.t 'application.my_profile'
    @user = User.find(session[:user_id])
    
     @has_profile = has_action_rights('org_profile')
      if @has_profile != 0
         flash[:notice] = I18n.t 'event_controller.not_access_page'        
         redirect_to(:controller => 'home', :action=>'index' ) and return # else redirect to reffered events
      end
    
      @user_multi = User.find(session[:user_id]) 
	 if @user_multi[:ref_id]!=nil && @user_multi[:ref_id]!="" 
		  @multi = 1
		  @ses_user = @user_multi[:ref_id]
	  else
		  @multi = 0
		  @ses_user = session[:user_id]
	  end
    
    if(params[:id])
#      @organizers = Organizer.find(:all, :conditions => ['user_id=? AND id!=? ', @ses_user, params[:id]])
      @organizers = Organizer.find(:all, :conditions => ['user_id=?', @ses_user])
      @org = Organizer.find(params[:id])
      @events = Event.find_live_org_events(@org[:id])
    else
     
      @organizers = Organizer.find(:all, :conditions => ['user_id=?', @ses_user])
      if @organizers.count > 0
        @org = @organizers[0]
        @events = Event.find_live_org_events(@org[:id])
      else  
        @org = Organizer.new
        @events = nil
      end 
      
    end
       
    
    @site = SiteSetting.find(:first)
    if request.post?   ########### after post starts #####
           
             respond_to do |format|
                
              
                if(params[:org_id]!=0 && params[:org_id]!='' && params[:org_id]!=nil)
                     
                     if @org.update_attributes(params[:org])
                         flash[:notice1] = (I18n.t 'users_controller.org_account_updated')
                         format.html { render :action => "profile" }
                         format.xml { render :xml => @org, :status => :created, :location => @org }
                      else
                        format.html { render :action => "profile" }
                        format.xml { render :xml => @org.errors, :status => :unprocessable_entity }
                      end
                    
                else  
                     @org = Organizer.new(params[:org])
                      if @org.save
                        flash[:notice1] = (I18n.t 'users_controller.org_info_save_successfully')
                        format.html { redirect_to :action => 'profile/'+@org[:id].to_s }
                        format.xml { render :xml => @org, :status => :created, :location => @org }
                      else
                        format.html { render :action => "profile" }
                        format.xml { render :xml => @org.errors, :status => :unprocessable_entity }
                      end
                end
             end 
            
     end ########## after post ends #####
       
  end

  # GET /users/new
  # GET /users/new.json
  def new
  
    @has_profile = has_action_rights('org_profile')
      if @has_profile != 0
         flash[:notice] = I18n.t 'event_controller.not_access_page'        
         redirect_to(:controller => 'home', :action=>'index' ) and return # else redirect to reffered events
      end
      
    @user = User.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @user }
    end
  end

  # GET /users/1/edit
  def edit 
     @has_profile = has_action_rights('org_profile')
      if @has_profile != 0
         flash[:notice] = I18n.t 'event_controller.not_access_page'        
         redirect_to(:controller => 'home', :action=>'index' ) and return # else redirect to reffered events
      end
      
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
   
    @has_profile = has_action_rights('org_profile')
      if @has_profile != 0
         flash[:notice] = I18n.t 'event_controller.not_access_page'        
         redirect_to(:controller => 'home', :action=>'index' ) and return # else redirect to reffered events
      end
  
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, :notice => (I18n.t 'users_controller.user_successfully_created') }
        format.json { render :json => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
  
   @has_profile = has_action_rights('org_profile')
      if @has_profile != 0
         flash[:notice] = I18n.t 'event_controller.not_access_page'        
         redirect_to(:controller => 'home', :action=>'index' ) and return # else redirect to reffered events
      end
  
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, :notice => (I18n.t 'users_controller.user_successfully_updated') }
        
      else
        format.html { render :action => "edit" }
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    
     @has_profile = has_action_rights('org_profile')
      if @has_profile != 0
         flash[:notice] = I18n.t 'event_controller.not_access_page'        
         redirect_to(:controller => 'home', :action=>'index' ) and return # else redirect to reffered events
      end
  
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      
    end
  end
  
  def org_uploading
  
  @has_profile = has_action_rights('org_profile')
      if @has_profile != 0
          @multi = 1
   	  render :json => { :success => true, :msg => { :image => '' , :error => 'true', :success => ''}  }
      else
	  post = User.saveimage(params[:upload])
	  render :json => { :success => true, :msg => { :image => post.as_json(), :error => '', :success => ''}  }
      end
      
  end

  def change_org_theme
     @one_theme = Theme.find(params[:theme_id])
     respond_to do |format|
         format.html  { render :template => 'users/_change_org_theme', :layout => false }
     end 
  end
  
end