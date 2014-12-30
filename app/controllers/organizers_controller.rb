class OrganizersController < ApplicationController
  
  def show
     @org = Organizer.find(params[:id])
     @site = SiteSetting.find(:first)
     
     @meta_title = @org[:name]#I18n.t 'meta_title.ticket_purchase'
     @meta_keyword = @org[:name].gsub(" ", ",")
     @meta_desc = @org[:name]
     
     
     if @org[:theme_id] > 0
       @one_theme = @org
     else 
       @one_theme = Theme.find_first_theme
     end
      @org_id = @org[:id]
     render :layout => 'application_login'
  end
  
=begin  
  def contact
    @org = Organizer.find(params[:id])
    @event_id = params[:event_id]
    
    if @event_id!='' && @event_id!=nil 
      @event = Event.find(@event_id)
      lang = Language.find_name(@event[:language_id])
      set_locale(lang)
    end
     
    if request.post?
        @org_con = OrgContact.new(params[:contact])
        @org_con.save
        UserMailer.org_contact_email(@org_con, params[:event_id]).deliver
        
        msg = I18n.t 'validation.orga_contact.msg_sent'  
        render :json => { :success => true, :msg => msg}   
    else
      render :layout => false
    end  
  end
=end

 def contact
    @org = Organizer.find(params[:id])
    @event_id = params[:event_id]
    
    if @event_id!='' && @event_id!=nil 
      @event = Event.find(@event_id)
      lang = Language.find_name(@event[:language_id])
      set_locale(lang)
    end
     
    if request.post?
        @org_con = OrgContact.new(params[:contact])
        @org_con.save
        
        ##render :text=> params[:contact][:organizer_id] and return
          @event = Event.find(params[:event_id])
          @org = Organizer.find(params[:contact][:organizer_id])
          @permission = Permission.find(:all ,:conditions =>['admin_id=?' ,@org[:user_id]])
          #render :text=> @permission.inspect and return
        
        UserMailer.org_contact_email(@org_con, params[:event_id]).deliver
        
        
          if(@permission.count >0 )
            @test = "0"
            for permission in @permission
                
                 @user = User.find(permission[:user_id])     
                 eact = 'contact_org'
                 @has_rights = Event.has_email_rights(@user, @event, eact)
                
                 if @has_rights == 1
                   @test = @test+","+@user[:id].to_s
                   UserMailer.org_contact_email_multi(@org_con, params[:event_id],@user).deliver
                 end
                      
            end
          end
       ## render :text => @test and return
        
        msg = I18n.t 'validation.orga_contact.msg_sent'  
        render :json => { :success => true, :msg => msg}   
    else
      render :layout => false
    end  
  end
  
  def custom_url
    @org = Organizer.find(:first, :conditions => ['page_url=?',params[:id]])
     @site = SiteSetting.find(:first)
     
     @meta_title = @org[:name]#I18n.t 'meta_title.ticket_purchase'
     @meta_keyword = @org[:name].gsub(" ", ",")
     @meta_desc = @org[:name]
     
     if @org[:theme_id] > 0
       @one_theme = @org
     else 
       @one_theme = Theme.find_first_theme
     end
      @org_id = @org[:id]
     render :layout => 'application_login', :template => 'organizers/show'
  end
  
end