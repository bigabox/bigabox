class ContactListsController < ApplicationController
  before_filter :authorize
  include ApplicationHelper
  
  def index
    @meta_title = I18n.t 'meta_title.can_list'
    @user = User.find(session[:user_id])
    @site = SiteSetting.find(:first)
    @has_invite = has_action_rights('send_invite')
      if @has_invite != 0
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
    
    
    if(params[:keyword])
        @contact_lists = ContactList.where("user_id = ? AND name like ?", @ses_user, "%#{params[:keyword]}%").paginate(:page => params[:page], :per_page => 5).order('id DESC')
    else
        @contact_lists = ContactList.where(:user_id => @ses_user).paginate(:page => params[:page], :per_page => 5).order('id DESC')
    end    
   
  end
  
  def new
    @meta_title = I18n.t 'meta_title.add_can_list'
    @user = User.find(session[:user_id])
    @site = SiteSetting.find(:first)
    
    @has_invite = has_action_rights('send_invite')
      if @has_invite != 0
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
    @contact_lists = ContactList.find(:all, :conditions => ['user_id=?',@ses_user])
     
     if request.post?
             @contact_list = ContactList.new(params[:contact_list])
         
         respond_to do |format|
         
               if @contact_list.save
                                           
                    if(params[:fetch_type]=='files')
                       Contact.import(params[:upload], @contact_list[:id])
                    end
                      
                    if(params[:fetch_type]=='manually')
                        ids = params[:emails]
                        
                        @newline = ids.split(/\r\n/)
                          i=0 
                          k=0
                           @newline.each do |n|
                               @commas = @newline[i].split(',')
                                j=0
                                 @commas.each do |c|
                                   
                                     if(@commas[j]!='')
                                       @cons = Contact.new
                                       @cons[:email] = c
                                       @cons[:contact_list_id] = @contact_list[:id]
                                       @cons.save
                                       k+=1
                                     end
                                    j+=1 
                                 end
                             i+=1
                           end
                           @contact_list[:cnt] = k
                           @contact_list.save
                      end
                    
                     
                      
                    flash[:notice1] = I18n.t 'notice.con_create_notice'
                    format.html { redirect_to(:action=>'index' ) }
                
                    format.xml  { render :xml => @contact_list, :status => :created, :location => @contact_list }
              else
                
                format.html { render :action => "new" }
                format.xml  { render :xml => @contact_list.errors, :status => :unprocessable_entity }
              end
          end
        
        else
           @contact_list = ContactList.new(params[:contact_list])
        end 
        
  end
  
  
  def copy
   
      @has_invite = has_action_rights('send_invite')
      if @has_invite != 0
         flash[:notice] = I18n.t 'event_controller.not_access_page'        
         redirect_to(:controller => 'home', :action=>'index' ) and return # else redirect to reffered events
      end
  
     @contact_list = ContactList.new
     if request.post?
             @contact_list = ContactList.new(params[:contact_list])
         
         respond_to do |format|
         
               if @contact_list.save
                    @old_list = ContactList.find(params[:id])    
                    @contacts = Contact.find(:all, :conditions => ['contact_list_id=? ',@old_list[:id]])                   
                    
                    for c in @contacts
                        @new = Contact.new
                        @new[:contact_list_id] = @contact_list[:id]
                        @new[:first_name] = c[:first_name]
                        @new[:last_name] = c[:last_name]
                        @new[:email] = c[:email]
                        @new[:unsubscribe] = c[:unsubscribe]
                        @new.save
                    end
                     
                     @contact_list[:cnt] = @old_list[:cnt]
                     @contact_list.save  
                    
                      
                    flash[:notice1] = I18n.t 'notice.con_copy_notice'
                    format.html { redirect_to(:action=>'index' ) }
                
                    format.xml  { render :xml => @contact_list, :status => :created, :location => @contact_list }
              else
                    format.html { render :action => "copy", :layout => false }
                    format.xml  { render :xml => @contact_list.errors, :status => :unprocessable_entity }
              end
          end
        
        else
           @contact_list = ContactList.new(params[:contact_list])
           render :layout => false
        end 
        
  end
  
  def delete
  
     @has_invite = has_action_rights('send_invite')
      if @has_invite != 0
         flash[:notice] = I18n.t 'event_controller.not_access_page'        
         redirect_to(:controller => 'home', :action=>'index' ) and return # else redirect to reffered events
      end
  
     respond_to do |format|
        @contact_list = ContactList.find(params[:id])
        Contact.destroy_all("contact_list_id = "+@contact_list[:id].to_s)
        @contact_list.destroy
        
        flash[:notice1] = I18n.t 'notice.con_delete_notice'
        format.html { redirect_to(:action=>'index' ) }
       
      end              
  end
  
  def invite
  
     @has_invite = has_action_rights('send_invite')
      if @has_invite != 0
         flash[:notice] = I18n.t 'event_controller.not_access_page'        
         redirect_to(:controller => 'home', :action=>'index' ) and return # else redirect to reffered events
      end
  
      if params[:action_form]=='invite'
          @id = params[:id]
          invite_id = params[:select_invitation_id]
          @invite = Invite.find(params[:select_invitation_id])
          @id.each do |i|
              send_invitation(i,@invite)
          end
       end
      flash[:notice1] = I18n.t 'notice.con_invitation_send_notice'
      redirect_to(:action=>'index' )
  end
  
  def select_invite
  
      @user_multi = User.find(session[:user_id]) 
	 if @user_multi[:ref_id]!=nil && @user_multi[:ref_id]!="" 
		  @multi = 1
		  @ses_user = @user_multi[:ref_id]
	  else
		  @multi = 0
		  @ses_user = session[:user_id]
	  end
  
    @live_events = Event.find_live_events(@ses_user)
    query = ' draft=0 AND event_id in ( select id from events where active = 1 AND cancel=0 AND user_id='+@ses_user.to_s+' AND event_end_date_time >= "'+Time.now.strftime('%Y-%m-%d %H:%M:%S').to_s+'")'
    
    @invites = Invite.find_by_sql('select * from invites where '+query+' ')
    render :layout => false
  end
  
  protected
  def send_invitation(cid,invite)
      @invite = invite
      @contact = Contact.find(:all, :conditions => ['unsubscribe=0 and contact_list_id=? ', cid])
      for c in @contact
         if c[:first_name]
            @name = c[:first_name]+' '+c[:last_name]
          else
            @name = '';
          end
        UserMailer.send_invite_email(@invite, c[:email], @name).deliver
        Contact.update_all(['last_mailed=? ', Time.now.strftime('%Y-%m-%d %H:%M:%S')],['id = ?', c[:id]])  
      end
  end
  
end
