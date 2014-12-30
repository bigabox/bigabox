class UserMailer < ActionMailer::Base
#  default :from => "anita.rockersinfo@gmail.com"
  default :from => "halfevent.rockersinfo@gmail.com"

  helper :application
  
  def test
  
    mail(:from => 'akash.rockersinfo@gmail.com', :reply_to => 'akash.rockersinfo@gmail.com', :to => 'rahul.rockersinfo@gmail.com', :subject => 'Hi Hello', :content_type => "text/html", :body => "THis is body")  
  end
  
  def welcome_email(user)
    @user = user
    @site = SiteSetting.find(:first)
        
    
    @logo_link = APP_CONFIG['development']['upload_url']+'data/orig/other/'+@site[:site_logo]
    @contact_link = APP_CONFIG['development']['site_url']+"home/contact_us"
    @about_link = APP_CONFIG['development']['site_url']+"content/about"
    @help_link = APP_CONFIG['development']['site_url']+"content/help"
    @privacy_link = APP_CONFIG['development']['site_url']+"content/privacy_policy"
    @terms_link = APP_CONFIG['development']['site_url']+"content/terms"
    @twitter_link = @site[:twitter_link]
    @facebook_link = @site[:facebook_link]
    
    if @user[:first_name]!=nil && @user[:first_name]!=''
      if @user[:last_name]!=nil && @user[:last_name]!=''
        @user_name = @user[:first_name]+' '+@user[:last_name]
      else
        @user_name = @user[:first_name]
      end
      else
        @user_name = ''
    end
    
    @site_name = @site[:site_name]
    @login_link =  APP_CONFIG['development']['site_url']+"home/login"
    
    @email = EmailTemplate.find(:first, :conditions => ['task=?', 'Welcome Email']) 
    @message = @email[:message]
    
    @message = @message.gsub('{logo_link}',@logo_link)
    @message = @message.gsub('{contact_link}',@contact_link)
    @message = @message.gsub('{about_link}',@about_link)
    @message = @message.gsub('{help_link}',@help_link)
    @message = @message.gsub('{privacy_link}',@privacy_link)
    @message = @message.gsub('{terms_link}',@terms_link)
    @message = @message.gsub('{twitter_link}',@twitter_link)
    @message = @message.gsub('{facebook_link}',@facebook_link)
    
    @message = @message.gsub('{user_name}',@user_name)
    @message = @message.gsub('{site_name}',@site_name)
    @message = @message.gsub('{login_link}',@login_link)
    
    @email[:subject] = @email[:subject].gsub('{site_name}',@site_name)
    mail(:from => @email[:from_name]+'<'+@email[:from_address]+'>', :reply_to => @email[:reply_address], :to => user.email, :subject => @email[:subject], :content_type => "text/html", :body => @message)
  end
  
  def create_event_email(event)
    @event = event
    @user = User.find(@event[:user_id])
    @site = SiteSetting.find(:first)
        
    
    @logo_link = APP_CONFIG['development']['upload_url']+'data/orig/other/'+@site[:site_logo]
    @contact_link = APP_CONFIG['development']['site_url']+"home/contact_us"
    @about_link = APP_CONFIG['development']['site_url']+"content/about"
    @help_link = APP_CONFIG['development']['site_url']+"content/help"
    @privacy_link = APP_CONFIG['development']['site_url']+"content/privacy_policy"
    @terms_link = APP_CONFIG['development']['site_url']+"content/terms"
    @twitter_link = @site[:twitter_link]
    @facebook_link = @site[:facebook_link]
    
     if @user[:first_name]!=nil && @user[:first_name]!=''
      if @user[:last_name]!=nil && @user[:last_name]!=''
        @user_name = @user[:first_name]+' '+@user[:last_name]
      else
        @user_name = @user[:first_name]
      end
    else
        @user_name = ''
    end
    
    @site_name = @site[:site_name]
    
    if @event[:event_url_link]=='' || @event[:event_url_link]==nil 
      @event_link = APP_CONFIG['development']['site_url']+'events/view/'+@event[:id].to_s 
    else
      @event_link = APP_CONFIG['development']['site_url']+'event/'+@event[:event_url_link]
    end
    
    @email = EmailTemplate.find(:first, :conditions => ['task=?', 'Create Event Email']) 
    @message = @email[:message]
    
    @message = @message.gsub('{logo_link}',@logo_link)
    @message = @message.gsub('{contact_link}',@contact_link)
    @message = @message.gsub('{about_link}',@about_link)
    @message = @message.gsub('{help_link}',@help_link)
    @message = @message.gsub('{privacy_link}',@privacy_link)
    @message = @message.gsub('{terms_link}',@terms_link)
    @message = @message.gsub('{twitter_link}',@twitter_link)
    @message = @message.gsub('{facebook_link}',@facebook_link)
    
    @message = @message.gsub('{user_name}',@user_name)
    @message = @message.gsub('{site_name}',@site_name)
    @message = @message.gsub('{event_link}',@event_link)
    @message = @message.gsub('{event_title}',@event[:event_title])
    
    @email[:subject] = @email[:subject].gsub('{site_name}',@site_name)
    mail(:from => @email[:from_name]+'<'+@email[:from_address]+'>', :reply_to => @email[:reply_address], :to => @user[:email], :subject => @email[:subject], :content_type => "text/html", :body => @message)
  end
  
  
  
  def make_event_live_request(event)
    @event = event
    @user = User.find(@event[:user_id])
    @site = SiteSetting.find(:first)
        
    
    @logo_link = APP_CONFIG['development']['upload_url']+'data/orig/other/'+@site[:site_logo]
    @contact_link = APP_CONFIG['development']['site_url']+"home/contact_us"
    @about_link = APP_CONFIG['development']['site_url']+"content/about"
    @help_link = APP_CONFIG['development']['site_url']+"content/help"
    @privacy_link = APP_CONFIG['development']['site_url']+"content/privacy_policy"
    @terms_link = APP_CONFIG['development']['site_url']+"content/terms"
    @twitter_link = @site[:twitter_link]
    @facebook_link = @site[:facebook_link]
    
    if @user[:first_name]!=nil && @user[:first_name]!=''
      if @user[:last_name]!=nil && @user[:last_name]!=''
        @user_name = @user[:first_name]+' '+@user[:last_name]
      else
        @user_name = @user[:first_name]
      end
    else
        @user_name = ''
    end
    
    @site_name = @site[:site_name]
    
    if @event[:event_url_link]=='' || @event[:event_url_link]==nil 
      @event_link = APP_CONFIG['development']['site_url']+'events/view/'+@event[:id].to_s 
    else
      @event_link = APP_CONFIG['development']['site_url']+'event/'+@event[:event_url_link]
    end
    
    @live_link = APP_CONFIG['development']['site_url']+'admin/events/manage/'+@event[:id].to_s 
    
    @email = EmailTemplate.find(:first, :conditions => ['task=?', 'Make Event Live Admin Alert']) 
    @message = @email[:message]
    
    @message = @message.gsub('{logo_link}',@logo_link)
    @message = @message.gsub('{contact_link}',@contact_link)
    @message = @message.gsub('{about_link}',@about_link)
    @message = @message.gsub('{help_link}',@help_link)
    @message = @message.gsub('{privacy_link}',@privacy_link)
    @message = @message.gsub('{terms_link}',@terms_link)
    @message = @message.gsub('{twitter_link}',@twitter_link)
    @message = @message.gsub('{facebook_link}',@facebook_link)
    
    @message = @message.gsub('{user_name}',@user_name)
    @message = @message.gsub('{site_name}',@site_name)
    @message = @message.gsub('{event_link}',@event_link)
    @message = @message.gsub('{live_link}',@live_link)
     
    @message = @message.gsub('{event_title}',@event[:event_title])
    
    @email[:subject] = @email[:subject].gsub('{site_name}',@site_name)
    mail(:from => @user[:email], :reply_to => @user[:email], :to => @email[:from_name]+'<'+@email[:from_address]+'>', :subject => @email[:subject], :content_type => "text/html", :body => @message)
  end
  
  def confirm_live_event(event)
    @event = event
    @user = User.find(@event[:user_id])
    @site = SiteSetting.find(:first)
        
    
    @logo_link = APP_CONFIG['development']['upload_url']+'data/orig/other/'+@site[:site_logo]
    @contact_link = APP_CONFIG['development']['site_url']+"home/contact_us"
    @about_link = APP_CONFIG['development']['site_url']+"content/about"
    @help_link = APP_CONFIG['development']['site_url']+"content/help"
    @privacy_link = APP_CONFIG['development']['site_url']+"content/privacy_policy"
    @terms_link = APP_CONFIG['development']['site_url']+"content/terms"
    @twitter_link = @site[:twitter_link]
    @facebook_link = @site[:facebook_link]
    
    if @user[:first_name]!=nil && @user[:first_name]!=''
      if @user[:last_name]!=nil && @user[:last_name]!=''
        @user_name = @user[:first_name]+' '+@user[:last_name]
      else
        @user_name = @user[:first_name]
      end
    else
        @user_name = ''
    end
    
    @site_name = @site[:site_name]
    
    if @event[:event_url_link]=='' || @event[:event_url_link]==nil 
      @event_link = APP_CONFIG['development']['site_url']+'events/view/'+@event[:id].to_s 
    else
      @event_link = APP_CONFIG['development']['site_url']+'event/'+@event[:event_url_link]
    end
    
    @email = EmailTemplate.find(:first, :conditions => ['task=?', 'Event Live User Alert']) 
    @message = @email[:message]
    
    @message = @message.gsub('{logo_link}',@logo_link)
    @message = @message.gsub('{contact_link}',@contact_link)
    @message = @message.gsub('{about_link}',@about_link)
    @message = @message.gsub('{help_link}',@help_link)
    @message = @message.gsub('{privacy_link}',@privacy_link)
    @message = @message.gsub('{terms_link}',@terms_link)
    @message = @message.gsub('{twitter_link}',@twitter_link)
    @message = @message.gsub('{facebook_link}',@facebook_link)
    
    @message = @message.gsub('{user_name}',@user_name)
    @message = @message.gsub('{site_name}',@site_name)
    @message = @message.gsub('{event_link}',@event_link)
    @message = @message.gsub('{event_title}',@event[:event_title])
    
    @email[:subject] = @email[:subject].gsub('{site_name}',@site_name)
    mail(:from => @email[:from_name]+'<'+@email[:from_address]+'>', :reply_to => @email[:reply_address], :to => @user[:email], :subject => @email[:subject], :content_type => "text/html", :body => @message)
  end
  
  def cancel_event_notification(event)
    @event = event
    @user = User.find(@event[:user_id])
    @site = SiteSetting.find(:first)
        
    
    @logo_link = APP_CONFIG['development']['upload_url']+'data/orig/other/'+@site[:site_logo]
    @contact_link = APP_CONFIG['development']['site_url']+"home/contact_us"
    @about_link = APP_CONFIG['development']['site_url']+"content/about"
    @help_link = APP_CONFIG['development']['site_url']+"content/help"
    @privacy_link = APP_CONFIG['development']['site_url']+"content/privacy_policy"
    @terms_link = APP_CONFIG['development']['site_url']+"content/terms"
    @twitter_link = @site[:twitter_link]
    @facebook_link = @site[:facebook_link]
    
    if @user[:first_name]!=nil && @user[:first_name]!=''
      if @user[:last_name]!=nil && @user[:last_name]!=''
        @user_name = @user[:first_name]+' '+@user[:last_name]
      else
        @user_name = @user[:first_name]
      end
    else
        @user_name = ''
    end
    
    @site_name = @site[:site_name]
    
    if @event[:event_url_link]=='' || @event[:event_url_link]==nil 
      @event_link = APP_CONFIG['development']['site_url']+'events/view/'+@event[:id].to_s 
    else
      @event_link = APP_CONFIG['development']['site_url']+'event/'+@event[:event_url_link]
    end
    
    @email = EmailTemplate.find(:first, :conditions => ['task=?', 'Event Cancel User Alert']) 
    @message = @email[:message]
    
    @message = @message.gsub('{logo_link}',@logo_link)
    @message = @message.gsub('{contact_link}',@contact_link)
    @message = @message.gsub('{about_link}',@about_link)
    @message = @message.gsub('{help_link}',@help_link)
    @message = @message.gsub('{privacy_link}',@privacy_link)
    @message = @message.gsub('{terms_link}',@terms_link)
    @message = @message.gsub('{twitter_link}',@twitter_link)
    @message = @message.gsub('{facebook_link}',@facebook_link)
    
    @message = @message.gsub('{user_name}',@user_name)
    @message = @message.gsub('{site_name}',@site_name)
    @message = @message.gsub('{event_link}',@event_link)
    @message = @message.gsub('{event_title}',@event[:event_title])
    
    @email[:subject] = @email[:subject].gsub('{site_name}',@site_name)
    mail(:from => @email[:from_name]+'<'+@email[:from_address]+'>', :reply_to => @email[:reply_address], :to => @user[:email], :subject => @email[:subject], :content_type => "text/html", :body => @message)
  end
 
  def verify_account_email(user)
    @user = user
    @site = SiteSetting.find(:first)
    @url  = APP_CONFIG['development']['site_url']+"home/confirm_user_account/"
    @verify_link  = @url+@user[:forgot_unique_code]
    
    @logo_link = APP_CONFIG['development']['upload_url']+'data/orig/other/'+@site[:site_logo]
    @contact_link = APP_CONFIG['development']['site_url']+"home/contact_us"
    @about_link = APP_CONFIG['development']['site_url']+"content/about"
    @help_link = APP_CONFIG['development']['site_url']+"content/help"
    @privacy_link = APP_CONFIG['development']['site_url']+"content/privacy_policy"
    @terms_link = APP_CONFIG['development']['site_url']+"content/terms"
    @twitter_link = @site[:twitter_link]
    @facebook_link = @site[:facebook_link]
    
    if @user[:first_name]!=nil && @user[:first_name]!=''
      if @user[:last_name]!=nil && @user[:last_name]!=''
        @user_name = @user[:first_name]+' '+@user[:last_name]
      else
        @user_name = @user[:first_name]
      end
    else
        @user_name = ''
    end
    
    @site_name = @site[:site_name]
   
    @email = EmailTemplate.find(:first, :conditions => ['task=?', 'Verify Account']) 
    @message = @email[:message]
    
    @message = @message.gsub('{logo_link}',@logo_link)
    @message = @message.gsub('{contact_link}',@contact_link)
    @message = @message.gsub('{about_link}',@about_link)
    @message = @message.gsub('{help_link}',@help_link)
    @message = @message.gsub('{privacy_link}',@privacy_link)
    @message = @message.gsub('{terms_link}',@terms_link)
    @message = @message.gsub('{twitter_link}',@twitter_link)
    @message = @message.gsub('{facebook_link}',@facebook_link)
    
    @message = @message.gsub('{user_name}',@user_name)
    @message = @message.gsub('{site_name}',@site_name)
    @message = @message.gsub('{verify_link}',@verify_link)
    
    @email[:subject] = @email[:subject].gsub('{site_name}',@site_name)
    mail(:from => @email[:from_name]+'<'+@email[:from_address]+'>', :reply_to => @email[:reply_address], :to => user.email, :subject => @email[:subject], :content_type => "text/html", :body => @message)
  end
  
  def verify_email_change(user)
    @user = user
    @site = SiteSetting.find(:first)
    @url  = APP_CONFIG['development']['site_url']+"manage_account/confirm_user_account/"
    @verify_link  = @url+@user[:forgot_unique_code]
    
    @logo_link = APP_CONFIG['development']['upload_url']+'data/orig/other/'+@site[:site_logo]
    @contact_link = APP_CONFIG['development']['site_url']+"home/contact_us"
    @about_link = APP_CONFIG['development']['site_url']+"content/about"
    @help_link = APP_CONFIG['development']['site_url']+"content/help"
    @privacy_link = APP_CONFIG['development']['site_url']+"content/privacy_policy"
    @terms_link = APP_CONFIG['development']['site_url']+"content/terms"
    @twitter_link = @site[:twitter_link]
    @facebook_link = @site[:facebook_link]
    
    if @user[:first_name]!=nil && @user[:first_name]!=''
      if @user[:last_name]!=nil && @user[:last_name]!=''
        @user_name = @user[:first_name]+' '+@user[:last_name]
      else
        @user_name = @user[:first_name]
      end
    else
        @user_name = ''
    end
    
    @site_name = @site[:site_name]
   
    @email = EmailTemplate.find(:first, :conditions => ['task=?', 'Verify Change Account']) 
    @message = @email[:message]
    
    @message = @message.gsub('{logo_link}',@logo_link)
    @message = @message.gsub('{contact_link}',@contact_link)
    @message = @message.gsub('{about_link}',@about_link)
    @message = @message.gsub('{help_link}',@help_link)
    @message = @message.gsub('{privacy_link}',@privacy_link)
    @message = @message.gsub('{terms_link}',@terms_link)
    @message = @message.gsub('{twitter_link}',@twitter_link)
    @message = @message.gsub('{facebook_link}',@facebook_link)
    
    @message = @message.gsub('{user_name}',@user_name)
    @message = @message.gsub('{site_name}',@site_name)
    @message = @message.gsub('{verify_link}',@verify_link)
    
    @email[:subject] = @email[:subject].gsub('{site_name}',@site_name)
    mail(:from => @email[:from_name]+'<'+@email[:from_address]+'>', :reply_to => @email[:reply_address], :to => user.new_email, :subject => @email[:subject], :content_type => "text/html", :body => @message)
  end
  
  def change_email_notification(user,email)
    @user = user
    @site = SiteSetting.find(:first)
    @new_email = @user[:email]
    
    @logo_link = APP_CONFIG['development']['upload_url']+'data/orig/other/'+@site[:site_logo]
    @contact_link = APP_CONFIG['development']['site_url']+"home/contact_us"
    @about_link = APP_CONFIG['development']['site_url']+"content/about"
    @help_link = APP_CONFIG['development']['site_url']+"content/help"
    @privacy_link = APP_CONFIG['development']['site_url']+"content/privacy_policy"
    @terms_link = APP_CONFIG['development']['site_url']+"content/terms"
    @twitter_link = @site[:twitter_link]
    @facebook_link = @site[:facebook_link]
    
    if @user[:first_name]!=nil && @user[:first_name]!=''
      if @user[:last_name]!=nil && @user[:last_name]!=''
        @user_name = @user[:first_name]+' '+@user[:last_name]
      else
        @user_name = @user[:first_name]
      end
    else
        @user_name = ''
    end

    
    @site_name = @site[:site_name]
   
    @email = EmailTemplate.find(:first, :conditions => ['task=?', 'Change Email']) 
    @message = @email[:message]
    
    @message = @message.gsub('{logo_link}',@logo_link)
    @message = @message.gsub('{contact_link}',@contact_link)
    @message = @message.gsub('{about_link}',@about_link)
    @message = @message.gsub('{help_link}',@help_link)
    @message = @message.gsub('{privacy_link}',@privacy_link)
    @message = @message.gsub('{terms_link}',@terms_link)
    @message = @message.gsub('{twitter_link}',@twitter_link)
    @message = @message.gsub('{facebook_link}',@facebook_link)
    
    @message = @message.gsub('{user_name}',@user_name)
    @message = @message.gsub('{site_name}',@site_name)
    @message = @message.gsub('{new_email}',@new_email)
    
    @email[:subject] = @email[:subject].gsub('{site_name}',@site_name)
    mail(:from => @email[:from_name]+'<'+@email[:from_address]+'>', :reply_to => @email[:reply_address], :to => email, :subject => @email[:subject], :content_type => "text/html", :body => @message)
  end
  
  def forgot_passwprd_email(id)
    user = User.find(id)
    @user = user
    @site = SiteSetting.find(:first)
    @url  = APP_CONFIG['development']['site_url']+"home/set_new_password/"
    @forgot_password_link  = @url+@user[:forgot_unique_code]
    
    @logo_link = APP_CONFIG['development']['upload_url']+'data/orig/other/'+@site[:site_logo]
    @contact_link = APP_CONFIG['development']['site_url']+"home/contact_us"
    @about_link = APP_CONFIG['development']['site_url']+"content/about"
    @help_link = APP_CONFIG['development']['site_url']+"content/help"
    @privacy_link = APP_CONFIG['development']['site_url']+"content/privacy_policy"
    @terms_link = APP_CONFIG['development']['site_url']+"content/terms"
    @twitter_link = @site[:twitter_link]
    @facebook_link = @site[:facebook_link]
    
    if @user[:first_name]!=nil && @user[:first_name]!=''
      if @user[:last_name]!=nil && @user[:last_name]!=''
        @user_name = @user[:first_name]+' '+@user[:last_name]
      else
        @user_name = @user[:first_name]
      end
    else
        @user_name = ''
    end
    
    @site_name = @site[:site_name]
   
    @email = EmailTemplate.find(:first, :conditions => ['task=?', 'Forgot Password']) 
    @message = @email[:message]
    
    @message = @message.gsub('{logo_link}',@logo_link)
    @message = @message.gsub('{contact_link}',@contact_link)
    @message = @message.gsub('{about_link}',@about_link)
    @message = @message.gsub('{help_link}',@help_link)
    @message = @message.gsub('{privacy_link}',@privacy_link)
    @message = @message.gsub('{terms_link}',@terms_link)
    @message = @message.gsub('{twitter_link}',@twitter_link)
    @message = @message.gsub('{facebook_link}',@facebook_link)
    
    @message = @message.gsub('{user_name}',@user_name)
    @message = @message.gsub('{site_name}',@site_name)
    @message = @message.gsub('{forget_password_link}',@forgot_password_link)
    
    @email[:subject] = @email[:subject].gsub('{site_name}',@site_name)
    mail(:from => @email[:from_name]+'<'+@email[:from_address]+'>', :reply_to => @email[:reply_address], :to => user.email, :subject => @email[:subject], :content_type => "text/html", :body => @message)
  end
 
  def multi_user_access(user,admin)
    @user = user
    @admin = admin
    @site = SiteSetting.find(:first)
    @url  = APP_CONFIG['development']['site_url']+"home/set_new_password/"
    @forgot_password_link  = @url+@user[:forgot_unique_code]
    
    @logo_link = APP_CONFIG['development']['upload_url']+'data/orig/other/'+@site[:site_logo]
    @contact_link = APP_CONFIG['development']['site_url']+"home/contact_us"
    @about_link = APP_CONFIG['development']['site_url']+"content/about"
    @help_link = APP_CONFIG['development']['site_url']+"content/help"
    @privacy_link = APP_CONFIG['development']['site_url']+"content/privacy_policy"
    @terms_link = APP_CONFIG['development']['site_url']+"content/terms"
    @twitter_link = @site[:twitter_link]
    @facebook_link = @site[:facebook_link]
    
    if @user[:first_name]!=nil && @user[:first_name]!=''
      if @user[:last_name]!=nil && @user[:last_name]!=''
        @user_name = @user[:first_name]+' '+@user[:last_name]
      else
        @user_name = @user[:first_name]
      end
    else
        @user_name = ''
    end
        
    if @admin[:first_name]!=nil && @admin[:first_name]!=''
      if @admin[:last_name]!=nil && @admin[:last_name]!=''
        @admin_name = @admin[:first_name]+' '+@admin[:last_name]
      else
        @admin_name = @admin[:first_name]
      end
    else
        @admin_name = ''
    end  
   
     
    @site_name = @site[:site_name]
   
    @email = EmailTemplate.find(:first, :conditions => ['task=?', 'Multiuser Access'])
    @message = @email[:message]
    
    @message = @message.gsub('{logo_link}',@logo_link)
    @message = @message.gsub('{contact_link}',@contact_link)
    @message = @message.gsub('{about_link}',@about_link)
    @message = @message.gsub('{help_link}',@help_link)
    @message = @message.gsub('{privacy_link}',@privacy_link)
    @message = @message.gsub('{terms_link}',@terms_link)
    @message = @message.gsub('{twitter_link}',@twitter_link)
    @message = @message.gsub('{facebook_link}',@facebook_link)
    
    @message = @message.gsub('{user_name}',@user_name)
    @message = @message.gsub('{site_name}',@site_name)
    @message = @message.gsub('{forget_password_link}',@forgot_password_link)
    @message = @message.gsub('{owner_name}',@admin_name)
    
    @email[:subject] = @email[:subject].gsub('{site_name}',@site_name)
    mail(:from => @email[:from_name]+'<'+@email[:from_address]+'>', :reply_to => @email[:reply_address], :to => user.email, :subject => @email[:subject], :content_type => "text/html", :body => @message)
  end 
  
 def confirm_order(order)
    @order = order
    @site = SiteSetting.find(:first)
    @event = Event.find(@order[:event_id])
    @form = OrderForm.find(:first, :conditions => ['event_id=?',@event[:id]])
    @ticket_link  = APP_CONFIG['development']['site_url']+"my_tickets/"
    @email = EmailTemplate.find(:first, :conditions => ['task=?', 'Confirm Order'])
   
    @logo_link = APP_CONFIG['development']['upload_url']+'data/orig/other/'+@site[:site_logo]
    @contact_link = APP_CONFIG['development']['site_url']+"home/contact_us"
    @about_link = APP_CONFIG['development']['site_url']+"content/about"
    @help_link = APP_CONFIG['development']['site_url']+"content/help"
    @privacy_link = APP_CONFIG['development']['site_url']+"content/privacy_policy"
    @terms_link = APP_CONFIG['development']['site_url']+"content/terms"
    @twitter_link = @site[:twitter_link]
    @facebook_link = @site[:facebook_link]


    if @form[:email_msg]!=nil && @form[:email_msg]!=''
       @confirm_msg = @form[:email_msg]  
    else
        @confirm_msg = ''
    end
    
    if @form[:reply_to_email]!=nil && @form[:reply_to_email]!=''
       @reply_address = @form[:reply_to_email]  
    else
        @reply_address = @email[:reply_address]
    end
    
    if @order[:first_name]!=nil && @order[:first_name]!=''
      if @order[:last_name]!=nil && @order[:last_name]!=''
        @user_name = @order[:first_name]+' '+@order[:last_name]
      else
        @user_name = @order[:first_name]
      end
    else
        @user_name = ''
    end
    
    if @event[:event_url_link]=='' || @event[:event_url_link]==nil 
      @event_link = APP_CONFIG['development']['site_url']+'events/view/'+@event[:id].to_s 
    else
      @event_link = APP_CONFIG['development']['site_url']+'event/'+@event[:event_url_link]
    end
    
    @site_name = @site[:site_name]
   
    
    @message = @email[:message]
    
    @message = @message.gsub('{logo_link}',@logo_link)
    @message = @message.gsub('{contact_link}',@contact_link)
    @message = @message.gsub('{about_link}',@about_link)
    @message = @message.gsub('{help_link}',@help_link)
    @message = @message.gsub('{privacy_link}',@privacy_link)
    @message = @message.gsub('{terms_link}',@terms_link)
    @message = @message.gsub('{twitter_link}',@twitter_link)
    @message = @message.gsub('{facebook_link}',@facebook_link)
    
    @message = @message.gsub('{user_name}',@user_name)
    @message = @message.gsub('{site_name}',@site_name)
    @message = @message.gsub('{event_link}',@event_link)
    @message = @message.gsub('{ticket_link}',@ticket_link)
    @message = @message.gsub('{event_title}',@event[:event_title])
    @message = @message.gsub('{confirm_msg}',@confirm_msg)
    
   
    
    @email[:subject] = @email[:subject].gsub('{site_name}',@site_name)
    #@form = OrderForm.find(:first, :conditions => ['event_id=?',@event[:id]])
    if @form && @form[:add_pdf_tickets]==1
       mail.attachments['ticket.pdf'] = File.read('public/data/docs/'+@order[:random_no]+'.pdf') 
       mail(:from => @email[:from_name]+'<'+@reply_address+'>', :reply_to => @reply_address, :to => order.email, :subject => @email[:subject])
    else
          mail(:from => @email[:from_name]+'<'+@reply_address+'>', :reply_to => @reply_address, :to => order.email, :subject => @email[:subject], :content_type => "text/html", :body => @message)  
    end  
      
  end
  
  def confirm_order_admin(order)
      @order = order
      @site = SiteSetting.find(:first)
      @event = Event.find(@order[:event_id])
      
     
      @logo_link = APP_CONFIG['development']['upload_url']+'data/orig/other/'+@site[:site_logo]
      @contact_link = APP_CONFIG['development']['site_url']+"home/contact_us"
      @about_link = APP_CONFIG['development']['site_url']+"content/about"
      @help_link = APP_CONFIG['development']['site_url']+"content/help"
      @privacy_link = APP_CONFIG['development']['site_url']+"content/privacy_policy"
      @terms_link = APP_CONFIG['development']['site_url']+"content/terms"
      @twitter_link = @site[:twitter_link]
      @facebook_link = @site[:facebook_link]
      
      if @order[:first_name]!=nil && @order[:first_name]!=''
      if @order[:last_name]!=nil && @order[:last_name]!=''
        @user_name = @order[:first_name]+' '+@order[:last_name]
      else
        @user_name = @order[:first_name]
      end
    else
        @user_name = ''
    end
      
      if @event[:event_url_link]=='' || @event[:event_url_link]==nil 
        @event_link = APP_CONFIG['development']['site_url']+'events/view/'+@event[:id].to_s 
      else
        @event_link = APP_CONFIG['development']['site_url']+'event/'+@event[:event_url_link]
      end
      
      @site_name = @site[:site_name]
     
      @email = EmailTemplate.find(:first, :conditions => ['task=?', 'Confirm Order Admin'])
      @message = @email[:message]
      
      @message = @message.gsub('{logo_link}',@logo_link)
      @message = @message.gsub('{contact_link}',@contact_link)
      @message = @message.gsub('{about_link}',@about_link)
      @message = @message.gsub('{help_link}',@help_link)
      @message = @message.gsub('{privacy_link}',@privacy_link)
      @message = @message.gsub('{terms_link}',@terms_link)
      @message = @message.gsub('{twitter_link}',@twitter_link)
      @message = @message.gsub('{facebook_link}',@facebook_link)
      
      @message = @message.gsub('{user_name}',@user_name)
      @message = @message.gsub('{site_name}',@site_name)
      @message = @message.gsub('{event_link}',@event_link)
      @message = @message.gsub('{event_title}',@event[:event_title])
      
      @email[:subject] = @email[:subject].gsub('{site_name}',@site_name)
      mail(:from => @email[:from_name]+'<'+@email[:from_address]+'>', :reply_to => @email[:reply_address], :to => @email[:from_address], :subject => @email[:subject], :content_type => "text/html", :body => @message)   
      
  end
  
   def confirm_order_org(order,event_org)
      @order = order
      @site = SiteSetting.find(:first)
      @event = Event.find(@order[:event_id])
      @event_org = event_org
     
      @logo_link = APP_CONFIG['development']['upload_url']+'data/orig/other/'+@site[:site_logo]
      @contact_link = APP_CONFIG['development']['site_url']+"home/contact_us"
      @about_link = APP_CONFIG['development']['site_url']+"content/about"
      @help_link = APP_CONFIG['development']['site_url']+"content/help"
      @privacy_link = APP_CONFIG['development']['site_url']+"content/privacy_policy"
      @terms_link = APP_CONFIG['development']['site_url']+"content/terms"
      @twitter_link = @site[:twitter_link]
      @facebook_link = @site[:facebook_link]
      
      if @order[:first_name]!=nil && @order[:first_name]!=''
      if @order[:last_name]!=nil && @order[:last_name]!=''
        @user_name = @order[:first_name]+' '+@order[:last_name]
      else
        @user_name = @order[:first_name]
      end
    else
        @user_name = ''
    end
      
      if @event[:event_url_link]=='' || @event[:event_url_link]==nil 
        @event_link = APP_CONFIG['development']['site_url']+'events/view/'+@event[:id].to_s 
      else
        @event_link = APP_CONFIG['development']['site_url']+'event/'+@event[:event_url_link]
      end
      
      @site_name = @site[:site_name]
      ## @event_org = User.find(@event[:user_id])
      @email = EmailTemplate.find(:first, :conditions => ['task=?', 'Confirm Order Org'])
      @message = @email[:message]
      
      @message = @message.gsub('{logo_link}',@logo_link)
      @message = @message.gsub('{contact_link}',@contact_link)
      @message = @message.gsub('{about_link}',@about_link)
      @message = @message.gsub('{help_link}',@help_link)
      @message = @message.gsub('{privacy_link}',@privacy_link)
      @message = @message.gsub('{terms_link}',@terms_link)
      @message = @message.gsub('{twitter_link}',@twitter_link)
      @message = @message.gsub('{facebook_link}',@facebook_link)
      
      @message = @message.gsub('{user_name}',@user_name)
      @message = @message.gsub('{site_name}',@site_name)
      @message = @message.gsub('{event_link}',@event_link)
      @message = @message.gsub('{event_title}',@event[:event_title])
      
      @email[:subject] = @email[:subject].gsub('{site_name}',@site_name)
      mail(:from => @email[:from_name]+'<'+@email[:from_address]+'>', :reply_to => @email[:reply_address], :to => @event_org[:email], :subject => @email[:subject], :content_type => "text/html", :body => @message)   
      
  end
  
  def cancel_order_event(order)
    @order = order
    @site = SiteSetting.find(:first)
    @event = Event.find(@order[:event_id])
    @cancel_link  = APP_CONFIG['development']['site_url']+"cancel_orders/"
   
    @logo_link = APP_CONFIG['development']['upload_url']+'data/orig/other/'+@site[:site_logo]
    @contact_link = APP_CONFIG['development']['site_url']+"home/contact_us"
    @about_link = APP_CONFIG['development']['site_url']+"content/about"
    @help_link = APP_CONFIG['development']['site_url']+"content/help"
    @privacy_link = APP_CONFIG['development']['site_url']+"content/privacy_policy"
    @terms_link = APP_CONFIG['development']['site_url']+"content/terms"
    @twitter_link = @site[:twitter_link]
    @facebook_link = @site[:facebook_link]
    
    if @order[:first_name]!=nil && @order[:last_name]!=nil
	@user_name = @order[:first_name]+' '+@order[:last_name]
    elsif @order[:first_name]!=nil && @order[:first_name]!=''
        @user_name = @order[:first_name]
    else
        @user_name = ''
    end
    
    if @event[:event_url_link]=='' || @event[:event_url_link]==nil 
      @event_link = APP_CONFIG['development']['site_url']+'events/view/'+@event[:id].to_s 
    else
      @event_link = APP_CONFIG['development']['site_url']+'event/'+@event[:event_url_link]
    end
    
    @site_name = @site[:site_name]
   
    @email = EmailTemplate.find(:first, :conditions => ['task=?', 'Cancel Order'])
    @message = @email[:message]
    
    @message = @message.gsub('{logo_link}',@logo_link)
    @message = @message.gsub('{contact_link}',@contact_link)
    @message = @message.gsub('{about_link}',@about_link)
    @message = @message.gsub('{help_link}',@help_link)
    @message = @message.gsub('{privacy_link}',@privacy_link)
    @message = @message.gsub('{terms_link}',@terms_link)
    @message = @message.gsub('{twitter_link}',@twitter_link)
    @message = @message.gsub('{facebook_link}',@facebook_link)
    
    @message = @message.gsub('{user_name}',@user_name)
    @message = @message.gsub('{site_name}',@site_name)
    @message = @message.gsub('{event_link}',@event_link)
    @message = @message.gsub('{cancel_link}',@cancel_link)
    @message = @message.gsub('{qty}',@order[:ticket_qty].to_s)
    
    @message = @message.gsub('{event_title}',@event[:event_title])
    
    @email[:subject] = @email[:subject].gsub('{site_name}',@site_name)
    #@form = OrderForm.find(:first, :conditions => ['event_id=?',@event[:id]])
    #if @form && @form[:add_pdf_tickets]==1
    #   mail.attachments['ticket.pdf'] = File.read('public/data/docs/'+@order[:random_no]+'_ticket_'+@order[:id].to_s+'.pdf') 
    #   mail(:from => @email[:from_name]+'<'+@email[:from_address]+'>', :reply_to => @email[:reply_address], :to => order.email, :subject => @email[:subject])
    #else
          mail(:from => @email[:from_name]+'<'+@email[:from_address]+'>', :reply_to => @email[:reply_address], :to => order.email, :subject => @email[:subject], :content_type => "text/html", :body => @message)  
    #end  
      
  end
  
  def contact_list_invite(user_id,contact_id)
        user = User.find(user_id)
        @user = user
        @con = Contact.find(contact_id)
        @site = SiteSetting.find(:first)
        
        
        @logo_link = APP_CONFIG['development']['upload_url']+'data/orig/other/'+@site[:site_logo]
        @contact_link = APP_CONFIG['development']['site_url']+"home/contact_us"
        @about_link = APP_CONFIG['development']['site_url']+"content/about"
        @help_link = APP_CONFIG['development']['site_url']+"content/help"
        @privacy_link = APP_CONFIG['development']['site_url']+"content/privacy_policy"
        @terms_link = APP_CONFIG['development']['site_url']+"content/terms"
        @twitter_link = @site[:twitter_link]
        @facebook_link = @site[:facebook_link]
        
        @site_link = APP_CONFIG['development']['site_url']
        
        if @con[:first_name]!=nil && @con[:first_name]!=''
          if @con[:last_name]!=nil && @con[:last_name]!=''
              @con_name = @con[:first_name]+' '+ @con[:last_name]
          else
              @con_name = @con[:first_name]
          end
        else
            @con_name = ''
        end
        
        if @user[:first_name]!=nil && @user[:first_name]!=''
          if @user[:last_name]!=nil && @user[:last_name]!=''
            @user_name = @user[:first_name]+' '+@user[:last_name]
          else
              @user_name = @user[:first_name]
          end
         else
              @user_name = ''
          end
        
        @site_name = @site[:site_name]
       
        @email = EmailTemplate.find(:first, :conditions => ['task=?', 'Contact List Invitation']) 
        @message = @email[:message]
        
        @message = @message.gsub('{logo_link}',@logo_link)
        @message = @message.gsub('{contact_link}',@contact_link)
        @message = @message.gsub('{about_link}',@about_link)
        @message = @message.gsub('{help_link}',@help_link)
        @message = @message.gsub('{privacy_link}',@privacy_link)
        @message = @message.gsub('{terms_link}',@terms_link)
        @message = @message.gsub('{twitter_link}',@twitter_link)
        @message = @message.gsub('{facebook_link}',@facebook_link)
        
        @message = @message.gsub('{site_link}',@site_link)
        @message = @message.gsub('{con_name}',@con_name)
        @message = @message.gsub('{user_name}',@user_name)
        @message = @message.gsub('{site_name}',@site_name)
        
        @email[:subject] = @email[:subject].gsub('{site_name}',@site_name)
        mail(:from => @email[:from_name]+'<'+@email[:from_address]+'>', :reply_to => @email[:reply_address], :to => @con[:email], :subject => @email[:subject], :content_type => "text/html", :body => @message)
  end
  
  def org_contact_email(org,event_id)
    @org_con = org
    @org = Organizer.find(@org_con[:organizer_id])
    @user = User.find(@org[:user_id])
    @site = SiteSetting.find(:first)
    
    
    @logo_link = APP_CONFIG['development']['upload_url']+'data/orig/other/'+@site[:site_logo]
    @contact_link = APP_CONFIG['development']['site_url']+"home/contact_us"
    @about_link = APP_CONFIG['development']['site_url']+"content/about"
    @help_link = APP_CONFIG['development']['site_url']+"content/help"
    @privacy_link = APP_CONFIG['development']['site_url']+"content/privacy_policy"
    @terms_link = APP_CONFIG['development']['site_url']+"content/terms"
    @twitter_link = @site[:twitter_link]
    @facebook_link = @site[:facebook_link]
    
   if @user[:first_name]!=nil && @user[:first_name]!='' && @user[:last_name]!=nil && @user[:last_name]!=''
        @user_name = @user[:first_name]+' '+@user[:last_name]
    elsif @user[:first_name]!=nil && @user[:first_name]!='' 
        @user_name = @user[:first_name]
    else
        @user_name = ''
    end 
    
    if @org[:name]!=nil && @org[:name]!=''
        @org_name = @org[:name]
    else
        @org_name = 'Unnamed Organizer'
    end 
    
    if @org[:page_url]=='' || @org[:page_url]==nil 
      @org_url = APP_CONFIG['development']['site_url']+'organizers/show/'+@org[:id].to_s 
    else
      @org_url = APP_CONFIG['development']['site_url']+'org/'+@org[:page_url]
    end
    
   
    @site_name = @site[:site_name]
   
    @email = EmailTemplate.find(:first, :conditions => ['task=?', 'Contact Organizer'])
    @message = @email[:message]
    
    @message = @message.gsub('{logo_link}',@logo_link)
    @message = @message.gsub('{contact_link}',@contact_link)
    @message = @message.gsub('{about_link}',@about_link)
    @message = @message.gsub('{help_link}',@help_link)
    @message = @message.gsub('{privacy_link}',@privacy_link)
    @message = @message.gsub('{terms_link}',@terms_link)
    @message = @message.gsub('{twitter_link}',@twitter_link)
    @message = @message.gsub('{facebook_link}',@facebook_link)
    
    @message = @message.gsub('{user_name}',@user_name)
    @message = @message.gsub('{site_name}',@site_name)
    @message = @message.gsub('{contact_name}', @org_con[:name])
    @message = @message.gsub('{message}', @org_con[:message])
    @message = @message.gsub('{org_name}', @org_name)
    @message = @message.gsub('{contact_email}', @org_con[:email])
    @message = @message.gsub('{org_link}', @org_url)
    
    if event_id!='' && event_id!=nil && event_id.to_i > 0
      @event = Event.find(event_id.to_i)
      event_title = 'From Event : '+@event[:event_title]
    else
      event_title = ''
    end
    @message = @message.gsub('{event_title}', event_title)
    
    @email[:subject] = @email[:subject].gsub('{site_name}',@site_name)
    mail(:from => @org_con[:name]+'<'+@org_con[:email]+'>', :reply_to => @org_con[:email] , :to => @user[:email], :subject => @email[:subject], :content_type => "text/html", :body => @message)
  end

def org_contact_email_multi(org,event_id,user)
    @org_con = org
    @org = Organizer.find(@org_con[:organizer_id])
    @user = user
    @site = SiteSetting.find(:first)
    
    
    @logo_link = APP_CONFIG['development']['upload_url']+'data/orig/other/'+@site[:site_logo]
    @contact_link = APP_CONFIG['development']['site_url']+"home/contact_us"
    @about_link = APP_CONFIG['development']['site_url']+"content/about"
    @help_link = APP_CONFIG['development']['site_url']+"content/help"
    @privacy_link = APP_CONFIG['development']['site_url']+"content/privacy_policy"
    @terms_link = APP_CONFIG['development']['site_url']+"content/terms"
    @twitter_link = @site[:twitter_link]
    @facebook_link = @site[:facebook_link]
    
    if @user[:first_name]!=nil && @user[:first_name]!=''
        @user_name = @user[:first_name]+' '+@user[:last_name]
    else
        @user_name = ''
    end 
    
    if @org[:name]!=nil && @org[:name]!=''
        @org_name = @org[:name]
    else
        @org_name = 'Unnamed Organizer'
    end 
    
    if @org[:page_url]=='' || @org[:page_url]==nil 
      @org_url = APP_CONFIG['development']['site_url']+'organizers/show/'+@org[:id].to_s 
    else
      @org_url = APP_CONFIG['development']['site_url']+'org/'+@org[:page_url]
    end
    
    @site_name = @site[:site_name]
   
    @email = EmailTemplate.find(:first, :conditions => ['task=?', 'Contact Organizer'])
    @message = @email[:message]
    
    @message = @message.gsub('{logo_link}',@logo_link)
    @message = @message.gsub('{contact_link}',@contact_link)
    @message = @message.gsub('{about_link}',@about_link)
    @message = @message.gsub('{help_link}',@help_link)
    @message = @message.gsub('{privacy_link}',@privacy_link)
    @message = @message.gsub('{terms_link}',@terms_link)
    @message = @message.gsub('{twitter_link}',@twitter_link)
    @message = @message.gsub('{facebook_link}',@facebook_link)
    
    @message = @message.gsub('{user_name}',@user_name)
    @message = @message.gsub('{site_name}',@site_name)
    @message = @message.gsub('{contact_name}', @org_con[:name])
    @message = @message.gsub('{message}', @org_con[:message])
    @message = @message.gsub('{contact_email}', @org_con[:email])
    @message = @message.gsub('{org_name}', @org_name)
    @message = @message.gsub('{org_link}', @org_url)
    
    if event_id!='' && event_id!=nil && event_id.to_i > 0
      @event = Event.find(event_id.to_i)
      event_title = 'From Event : '+@event[:event_title]
    else
      event_title = ''
    end
    @message = @message.gsub('{event_title}', event_title)
    
    @email[:subject] = @email[:subject].gsub('{site_name}',@site_name)
    mail(:from => @org_con[:name]+'<'+@org_con[:email]+'>', :reply_to => @org_con[:email] , :to => @user[:email], :subject => @email[:subject], :content_type => "text/html", :body => @message)
  end

  
  def send_invite_email(invite, email,name)
    @invite = invite
    @site = SiteSetting.find(:first)
    @event = Event.find(@invite[:event_id])
    @name = name
    
    #@invite[:subject] = @invite[:subject].gsub('{site_name}',@site[:site_name])
    mail(:to => email, :subject => @invite[:subject] , :reply_to => @invite[:reply_to], :from => @invite[:from_name]+' <'+@invite[:reply_to]+'> ' , :content_type => "text/html")
  end
  
  def contact_us_email(con)
    @con = con
    @site = SiteSetting.find(:first)
    #@user = User.find(@con[:user_id])
    
    @con_message=''
    @con_message=@con_message+'<br />I am : '+@con[:i_am]
    @con_message=@con_message+'<br />Category of my question : '+@con[:i_am]
    @con_message=@con_message+'<br />First Name : '+@con[:first_name]
    @con_message=@con_message+'<br />Last Name : '+@con[:last_name]
    @con_message=@con_message+'<br />Email Address : '+@con[:email]
    if @con[:url]!='' && @con[:url]!=nil
      @con_message=@con_message+'<br />Event Name/URL : '+@con[:url]
    end  
    @con_message=@con_message+'<br />Subject : '+@con[:subject]
    @con_message=@con_message+'<br />Details : '+@con[:details]
    
    @logo_link = APP_CONFIG['development']['upload_url']+'data/orig/other/'+@site[:site_logo]
    @contact_link = APP_CONFIG['development']['site_url']+"home/contact_us"
    @about_link = APP_CONFIG['development']['site_url']+"content/about"
    @help_link = APP_CONFIG['development']['site_url']+"content/help"
    @privacy_link = APP_CONFIG['development']['site_url']+"content/privacy_policy"
    @terms_link = APP_CONFIG['development']['site_url']+"content/terms"
    @twitter_link = @site[:twitter_link]
    @facebook_link = @site[:facebook_link]
    
    if @con[:first_name]!=nil && @con[:first_name]!=''
      if @con[:last_name]!=nil && @con[:last_name]!=''
        @user_name = @con[:first_name]+' '+ @con[:last_name]
      else
        @user_name = @con[:first_name]
      end
    else
        @user_name = ''
    end
   
    @site_name = @site[:site_name]
   
    @email = EmailTemplate.find(:first, :conditions => ['task=?', 'Contact Us'])
    @message = @email[:message]
    
    @message = @message.gsub('{logo_link}',@logo_link)
    @message = @message.gsub('{contact_link}',@contact_link)
    @message = @message.gsub('{about_link}',@about_link)
    @message = @message.gsub('{help_link}',@help_link)
    @message = @message.gsub('{privacy_link}',@privacy_link)
    @message = @message.gsub('{terms_link}',@terms_link)
    @message = @message.gsub('{twitter_link}',@twitter_link)
    @message = @message.gsub('{facebook_link}',@facebook_link)
    
    @message = @message.gsub('{user_name}',@user_name)
    @message = @message.gsub('{site_name}',@site_name)
    @message = @message.gsub('{message}',@con_message)
    
    @email[:subject] = @email[:subject].gsub('{site_name}',@site_name)
    mail(:from => @user_name+'<'+@con[:email]+'>', :reply_to => @con[:email], :to => @email[:from_address], :subject => @email[:subject], :content_type => "text/html", :body => @message)
  end
  
  def withdraw_request(user, with)
    @site = SiteSetting.find(:first)
    @user = user
    @with = with
    
    
    @logo_link = APP_CONFIG['development']['upload_url']+'data/orig/other/'+@site[:site_logo]
    @contact_link = APP_CONFIG['development']['site_url']+"home/contact_us"
    @about_link = APP_CONFIG['development']['site_url']+"content/about"
    @help_link = APP_CONFIG['development']['site_url']+"content/help"
    @privacy_link = APP_CONFIG['development']['site_url']+"content/privacy_policy"
    @terms_link = APP_CONFIG['development']['site_url']+"content/terms"
    @twitter_link = @site[:twitter_link]
    @facebook_link = @site[:facebook_link]
    
    if @user[:first_name]!=nil && @user[:first_name]!=''
      if @user[:last_name]!=nil && @user[:last_name]!=''
        @user_name = @user[:first_name]+' '+@user[:last_name]
      else
        @user_name = @user[:first_name]
      end
    else
        @user_name = ''
    end
   
    @site_name = @site[:site_name]
    
     @currency_symbol = @site[:currency_code]
     @currency_code = CurrencyCode.find(:first, :conditions => ['currency_code=?', @site[:currency_code]]) 
     @site[:currency_symbol] = @currency_code [:currency_symbol]
    
    @amount = @site[:currency_symbol]+@with[:withdraw_amount].to_s
    
    @email = EmailTemplate.find(:first, :conditions => ['task=?', 'Wallet Withdraw'])
    @message = @email[:message]
    
    @message = @message.gsub('{logo_link}',@logo_link)
    @message = @message.gsub('{contact_link}',@contact_link)
    @message = @message.gsub('{about_link}',@about_link)
    @message = @message.gsub('{help_link}',@help_link)
    @message = @message.gsub('{privacy_link}',@privacy_link)
    @message = @message.gsub('{terms_link}',@terms_link)
    @message = @message.gsub('{twitter_link}',@twitter_link)
    @message = @message.gsub('{facebook_link}',@facebook_link)
    
    @message = @message.gsub('{user_name}',@user_name)
    @message = @message.gsub('{site_name}',@site_name)
    @message = @message.gsub('{amount}',@amount.to_s)
    
    @email[:subject] = @email[:subject].gsub('{site_name}',@site_name)
    mail(:from => @user_name+'<'+@user[:email]+'>', :reply_to => @user[:email], :to => @email[:from_address], :subject => @email[:subject], :content_type => "text/html", :body => @message)
  end
  
  def confirm_withdraw_request(id)
    @site = SiteSetting.find(:first)
    @with = WalletWithdraw.find(id)
    @user = User.find(@with[:user_id])
    
    @logo_link = APP_CONFIG['development']['upload_url']+'data/orig/other/'+@site[:site_logo]
    @contact_link = APP_CONFIG['development']['site_url']+"home/contact_us"
    @about_link = APP_CONFIG['development']['site_url']+"content/about"
    @help_link = APP_CONFIG['development']['site_url']+"content/help"
    @privacy_link = APP_CONFIG['development']['site_url']+"content/privacy_policy"
    @terms_link = APP_CONFIG['development']['site_url']+"content/terms"
    @twitter_link = @site[:twitter_link]
    @facebook_link = @site[:facebook_link]
    
    if @user[:first_name]!=nil && @user[:first_name]!=''
      if @user[:last_name]!=nil && @user[:last_name]!=''
        @user_name = @user[:first_name]+' '+@user[:last_name]
      else
        @user_name = @user[:first_name]
      end
    else
        @user_name = ''
    end
   
    @site_name = @site[:site_name]
    
     @currency_symbol = @site[:currency_code]
     @currency_code = CurrencyCode.find(:first, :conditions => ['currency_code=?', @site[:currency_code]]) 
     @site[:currency_symbol] = @currency_code [:currency_symbol]
    
    @amount = @site[:currency_symbol]+@with[:withdraw_amount].to_s
    
    @email = EmailTemplate.find(:first, :conditions => ['task=?', 'Confirm Withdraw'])
    @message = @email[:message]
    
    @message = @message.gsub('{logo_link}',@logo_link)
    @message = @message.gsub('{contact_link}',@contact_link)
    @message = @message.gsub('{about_link}',@about_link)
    @message = @message.gsub('{help_link}',@help_link)
    @message = @message.gsub('{privacy_link}',@privacy_link)
    @message = @message.gsub('{terms_link}',@terms_link)
    @message = @message.gsub('{twitter_link}',@twitter_link)
    @message = @message.gsub('{facebook_link}',@facebook_link)
    
    @message = @message.gsub('{user_name}',@user_name)
    @message = @message.gsub('{site_name}',@site_name)
    @message = @message.gsub('{amount}',@amount.to_s)
    
    @email[:subject] = @email[:subject].gsub('{site_name}',@site_name)
    mail(:from => @email[:from_name]+'<'+@email[:from_address]+'>', :reply_to => @email[:reply_address], :to => @user[:email], :subject => @email[:subject], :content_type => "text/html", :body => @message)
  end
  
  def confirm_cancel_withdraw_request(id)
     @site = SiteSetting.find(:first)
     @can = CancelOrder.find(id)
     
    
    @logo_link = APP_CONFIG['development']['upload_url']+'data/orig/other/'+@site[:site_logo]
    @contact_link = APP_CONFIG['development']['site_url']+"home/contact_us"
    @about_link = APP_CONFIG['development']['site_url']+"content/about"
    @help_link = APP_CONFIG['development']['site_url']+"content/help"
    @privacy_link = APP_CONFIG['development']['site_url']+"content/privacy_policy"
    @terms_link = APP_CONFIG['development']['site_url']+"content/terms"
    @twitter_link = @site[:twitter_link]
    @facebook_link = @site[:facebook_link]
    
    if @can[:first_name]!=nil && @can[:first_name]!=''
      if @can[:last_name]!=nil && @can[:last_name]!=''
        @user_name = @can[:first_name]+' '+ @can[:last_name]
      else
        @user_name = @can[:first_name]
      end
    else
        @user_name = ''
    end
   
    @site_name = @site[:site_name]
    
     @currency_symbol = @site[:currency_code]
     @currency_code = CurrencyCode.find(:first, :conditions => ['currency_code=?', @site[:currency_code]]) 
     @site[:currency_symbol] = @currency_code [:currency_symbol]
    
    @amount = @site[:currency_symbol]+@can[:total].to_s
    
    @email = EmailTemplate.find(:first, :conditions => ['task=?', 'Confirm Cancel Withdraw'])
    @message = @email[:message]
    
    @message = @message.gsub('{logo_link}',@logo_link)
    @message = @message.gsub('{contact_link}',@contact_link)
    @message = @message.gsub('{about_link}',@about_link)
    @message = @message.gsub('{help_link}',@help_link)
    @message = @message.gsub('{privacy_link}',@privacy_link)
    @message = @message.gsub('{terms_link}',@terms_link)
    @message = @message.gsub('{twitter_link}',@twitter_link)
    @message = @message.gsub('{facebook_link}',@facebook_link)
    
    @message = @message.gsub('{user_name}',@user_name)
    @message = @message.gsub('{site_name}',@site_name)
    @message = @message.gsub('{amount}',@amount.to_s)
    
    @email[:subject] = @email[:subject].gsub('{site_name}',@site_name)
    mail(:from => @email[:from_name]+'<'+@email[:from_address]+'>', :reply_to => @email[:reply_address], :to => @can[:email], :subject => @email[:subject], :content_type => "text/html", :body => @message)
 
  end
  
  def confirm_paypal(status,pay_gross,custom_amt,chk_transaction_id,txn_id,payee_email,pay_id)
    @message = status.to_s+'/'+pay_gross.to_s+'/'+custom_amt.to_s+'/'+chk_transaction_id.to_s+'/'+txn_id.to_s+'/'+payee_email.to_s+'/'+pay_id.to_s
     mail(:from => 'jasmin.rockersinfo@gmail.com', :reply_to =>  'jasmin.rockersinfo@gmail.com', :to =>  'anita.rockersinfo@gmail.com', :subject =>  'Paypal Response', :content_type => "text/html", :body => @message)
  end
  
  def api_key_generated(user,key)
    @user = user
    @key = key
    @site = SiteSetting.find(:first)
    @url  = APP_CONFIG['development']['site_url']
    
    mail(:to => @user[:email], :subject => "API Key generated from "+@site[:site_name], :content_type => "text/html")
 end 
  
   def newsletter_job(news_id,user_id)
    @news_templete=NewsletterTemplate.find(news_id)
    @news_subject=@news_templete[:subject]
    @message=@news_templete[:template_content]
    
    @from_name=@news_templete[:from_name]
    @from_address=@news_templete[:from_address]
    @from_reply_address=@news_templete[:reply_address]
      
    @news_to=User.find(user_id)
    @user_email=@news_to[:email]
    
   
   # mail.attachments['NewJobOffer.docx'] = File.read('public/data/newsletter/News_2_Rahul.docx')
    mail(:from => @from_name +'<'+ @from_address +'>' ,:reply_to => @from_reply_address , :to => @user_email ,:subject => @news_subject,:content_type => "text/html" , :body => @message)
    
  end
  
 def confirm_order_attendee(order, pur)
    @order = order
    @pur = pur
    
    @site = SiteSetting.find(:first)
    @event = Event.find(@order[:event_id])
    @form = OrderForm.find(:first, :conditions => ['event_id=?',@event[:id]])
   #@ticket_link  = APP_CONFIG['development']['site_url']+"my_tickets/"
    @email = EmailTemplate.find(:first, :conditions => ['task=?', 'Confirm Order Attendee'])
   
    @logo_link = APP_CONFIG['development']['upload_url']+'data/orig/other/'+@site[:site_logo]
    @contact_link = APP_CONFIG['development']['site_url']+"home/contact_us"
    @about_link = APP_CONFIG['development']['site_url']+"content/about"
    @help_link = APP_CONFIG['development']['site_url']+"content/help"
    @privacy_link = APP_CONFIG['development']['site_url']+"content/privacy_policy"
    @terms_link = APP_CONFIG['development']['site_url']+"content/terms"
    @twitter_link = @site[:twitter_link]
    @facebook_link = @site[:facebook_link]


    if @form[:email_msg]!=nil && @form[:email_msg]!=''
       @confirm_msg = @form[:email_msg]  
    else
        @confirm_msg = ''
    end
    
    if @form[:reply_to_email]!=nil && @form[:reply_to_email]!=''
       @reply_address = @form[:reply_to_email]  
    else
        @reply_address = @email[:reply_address]
    end
    
    if @order[:first_name]!=nil && @order[:first_name]!=''
      if @order[:last_name]!=nil && @order[:last_name]!=''
        @user_name = @order[:first_name]+' '+@order[:last_name]
      else
        @user_name = @order[:first_name]
      end
    else
        @user_name = ''
    end

   if @pur[:first_name]!=nil && @pur[:first_name]!=''
      if @pur[:last_name]!=nil && @pur[:last_name]!=''
        @buyer_name = @pur[:first_name]+' '+@pur[:last_name]
      else
        @buyer_name = @pur[:first_name]
      end
    else
        @buyer_name = ''
    end

    
    if @event[:event_url_link]=='' || @event[:event_url_link]==nil 
      @event_link = APP_CONFIG['development']['site_url']+'events/view/'+@event[:id].to_s 
    else
      @event_link = APP_CONFIG['development']['site_url']+'event/'+@event[:event_url_link]
    end
    
    @site_name = @site[:site_name]
   
    @message = @email[:message]
    
    @message = @message.gsub('{logo_link}',@logo_link)
    @message = @message.gsub('{contact_link}',@contact_link)
    @message = @message.gsub('{about_link}',@about_link)
    @message = @message.gsub('{help_link}',@help_link)
    @message = @message.gsub('{privacy_link}',@privacy_link)
    @message = @message.gsub('{terms_link}',@terms_link)
    @message = @message.gsub('{twitter_link}',@twitter_link)
    @message = @message.gsub('{facebook_link}',@facebook_link)
    
    @message = @message.gsub('{user_name}',@user_name)
    @message = @message.gsub('{site_name}',@site_name)
    @message = @message.gsub('{event_link}',@event_link)
   #@message = @message.gsub('{ticket_link}',@ticket_link)
    @message = @message.gsub('{event_title}',@event[:event_title])
    @message = @message.gsub('{confirm_msg}',@confirm_msg)
    @message = @message.gsub('{buyer_name}',@buyer_name)
    
    @email[:subject] = @email[:subject].gsub('{site_name}',@site_name)
    #@form = OrderForm.find(:first, :conditions => ['event_id=?',@event[:id]])
    #if @form && @form[:add_pdf_tickets]==1
      # mail.attachments['ticket.pdf'] = File.read('public/data/docs/'+order[:random_no]+'.pdf') 
      # mail(:from => @email[:from_name]+'<'+@reply_address+'>', :reply_to => @reply_address, :to => order.email, :subject => @email[:subject])
   # else
       mail(:from => @email[:from_name]+'<'+@reply_address+'>', :reply_to => @reply_address, :to => order.email, :subject => @email[:subject], :content_type => "text/html", :body => @message)  
    # end  
      
  end    
  
end