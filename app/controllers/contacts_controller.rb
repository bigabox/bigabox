class ContactsController < ApplicationController
  before_filter :authorize
  include ApplicationHelper
  
    
    def index
      @ids = params[:list_id].split('_')
      
       @has_invite = has_action_rights('send_invite')
      if @has_invite != 0
         flash[:notice] = I18n.t 'event_controller.not_access_page'        
         redirect_to(:controller => 'home', :action=>'index' ) and return # else redirect to reffered events
      end
      
      @contacts = Contact.find(@ids)
      respond_to do |format|
        #format.html
        @contact_list = ContactList.find(params[:id])
        filename = @contact_list[:name]+".csv"
        format.csv{ headers["Content-Disposition"] = "attachment; filename=\"#{filename}\"" }
        #format.csv #{ send_data @products.to_csv }
        format.xls # { send_data @products.to_csv(col_sep: "\t") }
      end
      
    end
    
    
    
    def import
      Contact.import(params[:file], params[:contact_list_id])
      redirect_to root_url, :notice => (I18n.t 'contact_controller.products_imported')
    end
    


  def list
    @meta_title = I18n.t 'meta_title.contacts_list'
  
     @has_invite = has_action_rights('send_invite')
      if @has_invite != 0
         flash[:notice] = I18n.t 'event_controller.not_access_page'        
         redirect_to(:controller => 'home', :action=>'index' ) and return # else redirect to reffered events
      end
    
    @user = User.find(session[:user_id])

	 if @user[:ref_id]!=nil && @user[:ref_id]!="" 
		  @multi = 1
		  @ses_user = @user[:ref_id]
	  else
		  @multi = 0
		  @ses_user = session[:user_id]
	  end
    
    @site = SiteSetting.find(:first)
    if params[:id]
      @contact_list = ContactList.find(params[:id])
    else
      @contact_list = ContactList.find(:first, :conditions => ['user_id=? ', @ses_user])
    end
    
    @contacts = Contact.where(:contact_list_id => @contact_list[:id]).paginate(:page => params[:page], :per_page => 5).order('id DESC')
   
  end
  
  def rename
     @contact_list = ContactList.find(params[:list_id])
     @contact_list[:name] = params[:name]
      if @contact_list.save
             render :json => { :success => true, :msg => { :name => params[:name].as_json(), :error => '', :success => ''}  } 
       else
             render :json => { :success => true, :msg => { :name => '', :error => (I18n.t 'contact_controller.already_error'), :success => ''}  } 
      end
 
  end
  
   def edit
     @contact = Contact.find(params[:id])
     @contact[:first_name] = params[:first_name]
     @contact[:last_name] = params[:last_name]
     @contact[:email] = params[:email]
     @contact.save
     render :json => { :success => true, :msg => { :name => (I18n.t 'contact_controller.success'), :error => '', :success => ''}  } 
  end
  
  
  def unsubscribe
  
   @has_invite = has_action_rights('send_invite')
      if @has_invite != 0
         flash[:notice] = I18n.t 'event_controller.not_access_page'        
         redirect_to(:controller => 'home', :action=>'index' ) and return # else redirect to reffered events
      end
  
     @contact = Contact.find(params[:id])
     @contact[:unsubscribe] = 1
     @contact.save
    
     flash[:notice1] = I18n.t 'contact_controller.contact_record_unsubscribed'
     redirect_to(:action=>'list/'+@contact[:contact_list_id].to_s)
  end
  
  def delete
  
   @has_invite = has_action_rights('send_invite')
      if @has_invite != 0
         flash[:notice] = I18n.t 'event_controller.not_access_page'        
         redirect_to(:controller => 'home', :action=>'index' ) and return # else redirect to reffered events
      end
  
    @contact = Contact.find(params[:id])
    id = @contact[:contact_list_id]
    @contact.destroy
    
      @contact_list = ContactList.find(id)
      @contact_list[:cnt] = @contact_list[:cnt]-1
      @contact_list.save
                  
    flash[:notice1] = I18n.t 'contact_controller.contact_record_deleted_successfully'
    redirect_to(:action=>'list/'+id.to_s)
  end
  
  
  def action
  
   @has_invite = has_action_rights('send_invite')
      if @has_invite != 0
         flash[:notice] = I18n.t 'event_controller.not_access_page'        
         redirect_to(:controller => 'home', :action=>'index' ) and return # else redirect to reffered events
      end
  
     if request.post?
         @contact_list = ContactList.find(params[:contact_list_id])
             
             @id = params[:id]
             
             ### if action=delete
              if params[:action_form]=='delete'
                   k=0
                  @id.each do |i|
                      id = @id[k].to_s
                      @contact = Contact.find(id)
                      @contact.destroy
                      k+=1
                  end
                  
                  @contact_list[:cnt] = @contact_list[:cnt]-@id.count
                  @contact_list.save
                   flash[:notice1] = I18n.t 'contact_controller.record_deleted_successfully'
               end    
              #####
              ### if action=invite
              if params[:action_form]=='invite'
                  @invite = Invite.find(params[:select_invitation_id])
                  @id.each do |i|
                      @con = Contact.find(i)
                      if(@con[:unsubscribe]==0)
                          if @con[:first_name]
                            @name = @con[:first_name]+' '+@con[:last_name]
                          else
                            @name = '';
                          end
                          UserMailer.send_invite_email(@invite, @con[:email], @name).deliver
                          Contact.update_all(['last_mailed=? ', Time.now.strftime('%Y-%m-%d %H:%M:%S')],['id = ?', @con[:id]])  
                      end   
                  end
                   flash[:notice1] = I18n.t 'contact_controller.invitation_send'
               end    
              #####
                    redirect_to(:action=>'list/'+@contact_list[:id].to_s ) 
         
     end      
  end
  
  
  def add_new
    @user = User.find(session[:user_id])
    @site = SiteSetting.find(:first)
    @contact_list = ContactList.find(params[:id])
     
      @has_invite = has_action_rights('send_invite')
      if @has_invite != 0
         flash[:notice] = I18n.t 'event_controller.not_access_page'        
         redirect_to(:controller => 'home', :action=>'index' ) and return # else redirect to reffered events
      end
     
        if request.post?
            
         respond_to do |format|
         
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
                           @contact_list[:cnt] += k
                           @contact_list.save
                      end
                    
                      
                    flash[:notice1] = I18n.t 'contact_controller.contact_record_successfully'
                    format.html { redirect_to(:action=>'list/'+@contact_list[:id].to_s ) }
                
                    format.xml  { render :xml => @contact_list, :status => :created, :location => @contact_list }
              
          end
        
        else
          render :layout => false
        end
  end
  
  
  def copy
  
    @has_invite = has_action_rights('send_invite')
      if @has_invite != 0
         flash[:notice] = I18n.t 'event_controller.not_access_page'        
         redirect_to(:controller => 'home', :action=>'index' ) and return # else redirect to reffered events
      end
  
    if request.post?
        
        @list = ContactList.new(params[:contact_list])
        if @list.save
            @ids = params[:list_id].split('_')
             
            for i in @ids
              @con = Contact.find(i)
              @new = @con.dup
              @new[:contact_list_id] = @list[:id]
              @new.save
            end
            @list[:cnt] = @ids.count
            @list.save
            render :json => { :success => true, :msg => (I18n.t 'contact_controller.success'), :suc => (I18n.t 'contact_controller.new_record_successfully')  }
       else
            render :json => { :success => true, :msg => (I18n.t 'contact_controller.error'), :err => @list.errors.full_messages[0]  }  
       end        
    else
        render :layout => false    
    end
  end
  
  
end
