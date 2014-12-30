class EventsController < ApplicationController
  before_filter :authorize, :except => [:custom_url, :view, :test]
   include ApplicationHelper
  #before_filter :set_locale, :only => [:custom_url, :view, :event_theme_page]
  
def test
 UserMailer.test.deliver
end

  ########## event list #########
  def index
     @meta_title = I18n.t 'meta_title.my_event'
   
       ## Multiuser session[:user_id] assign   

  
  @user_multi = User.find(session[:user_id]) 
     if @user_multi[:ref_id]!=nil && @user_multi[:ref_id]!="" 
        @multi = 1
        @ses_user = @user_multi[:ref_id] 
      else
        @multi = 0
        @ses_user = session[:user_id]  
      end
  
   
      if params[:org_id]!='' && params[:org_id]!=nil
           @live_events = Event.find_live_org_session_events(@ses_user, params[:org_id])
           @draft_events = Event.find_draft_org_session_events(@ses_user, params[:org_id])
           @pass_events = Event.find_pass_org_session_events(@ses_user, params[:org_id])
           @cancel_events = Event.find_cancel_org_session_events(@ses_user, params[:org_id])
      else
           @live_events = Event.find_live_events(@ses_user)
           @draft_events = Event.find_draft_events(@ses_user)
           @pass_events = Event.find_pass_events(@ses_user)
           @cancel_events = Event.find_cancel_events(@ses_user)
      end
=begin     
     # for multi user access 
     @user = User.find(session[:user_id])
     act="create_event"
     # check if user is reffered
      if @user[:ref_id]!=nil && @user[:ref_id]!='' && @user[:ref_id] > 0
          #Check persmission
          @permission = Permission.find(:first, :conditions => ['user_id=? AND admin_id=?', @user[:id], @user[:ref_id]]) 
          @per_act = @permission[:action].split(',')
           if ((@permission[:action]=='all' || @per_act.include?(act)) )
                @has = 1 # if user has right to create event/my events procced
           else
                redirect_to(:controller => 'events', :action=>'referrer_events' ) # else redirect to reffered events
           end 
        @reffer = 1
     else
        @reffer = 0  
     end
=end     
     @site = SiteSetting.find(:first)
     
  end
  
  def referrer_events
     @meta_title = I18n.t 'event_title.referred_events'
     @site = SiteSetting.find(:first)
     @user = User.find(session[:user_id])
     
      if @user[:ref_id]!=nil && @user[:ref_id]!='' && @user[:ref_id] > 0 
         @live_events = Event.find_live_events(@user[:ref_id])
         @draft_events = Event.find_draft_events(@user[:ref_id])
         @pass_events = Event.find_pass_events(@user[:ref_id])  
         @cancel_events = Event.find_cancel_events(@user[:ref_id])
     else
         flash[:notice] = 'You do not have any Referrer..!!'        
         redirect_to(:controller => 'events', :action=>'index' )
     end     
  end
  
  def download_excel
    if params[:org_id]!='' && params[:org_id]!=nil
           @events = Event.find_live_org_session_events(session[:user_id], params[:org_id])
    else
           @events = Event.find_live_events(session[:user_id])
    end
     respond_to do |format|
        format.xls # { send_data @products.to_csv(col_sep: "\t") }
     end
  end
  ########  event list ends ###########
  
     ########### create_event starts #####
  def create_event 
     @meta_title = I18n.t 'meta_title.set_event_title'
     @user = User.find(session[:user_id])

     if params[:event_prev_id]=='' || params[:event_prev_id]==nil || params[:event_prev_id]==0
        @has =  has_action_rights('create_event')
     else
        @has =  has_action_rights('edit_event')
     end

    
    if @has ==1
        flash[:notice] = I18n.t 'event_controller.not_access_page'        
  redirect_to(:controller => 'home', :action=>'index' ) and return # else redirect to reffered events
    else
        # This will solve double redirect error 
    end 
     
      
     if request.post?   ########### after post starts #####
               
                @user = User.find(session[:user_id])     
                  
                  
                   if params[:event_prev_id]=='' || params[:event_prev_id]==nil || params[:event_prev_id]==0
                      @event = Event.new(params[:event])
                   else
                       @event = Event.find(params[:event_prev_id])
                       
                   end
                   
                  
              respond_to do |format|
                  
                  
                  if(@event[:online_event_option]==1) then
                       @event[:street_address] = params[:street_address2]
                       params[:event][:street_address] = params[:street_address2]
                  else
                       @event[:street_address] = params[:street_address1]  
                        params[:event][:street_address] = params[:street_address1] 
                  end 
                 
                    
                 saved = 1
                   if params[:event_prev_id]=='' || params[:event_prev_id]==nil || params[:event_prev_id]==0
                        if(@event[:event_repeat] == '' || @event[:event_repeat]==nil)
                           @event[:event_repeat] = 0
                        end
                       
                        if @event.save
                          event_id = @event[:id] #Event.maximum('id')
                           @order_form = OrderForm.new
	                   @order_form[:event_id] = @event[:id]
	                   @order_form[:reply_to_email] = @user[:email]
	                   @order_form.save
                          UserMailer.create_event_email(@event).deliver
                       else
                          saved = 0
                       end     
                   else
                    
                            
                     
                       if @event.update_attributes(params[:event])
                          event_id = params[:event_prev_id]
                       else
                          saved = 0
                       end     
                   end
                   
                  if saved == 1
                   
                   ## add event id to multiusers permission 
                   if params[:event][:user_id].to_i == @user[:ref_id]
                  
                       @permission = Permission.find(:first, :conditions => ['user_id=?', session[:user_id]])
                       if @permission[:event] !='all'
                         
                         # adding new created event to multiuser permission too if not all event permission.
                         @permission_new = event_id.to_s+","+@permission[:event].to_s
                         
                        @test = Permission.update(@permission[:id], :event => @permission_new)
                       end
                                              
                    end
                    
                  ## add event id to multiusers permission 
                   
                  
                    ########### organizer section start  ###############
                    
                     if params[:event][:organizer_host]==''
                       params[:event][:organizer_host] = 'Unnamed Organizer'
                     end   
                    
                    
                         
                    if(params[:event][:organizer_id]==0 || params[:event][:organizer_id]=='0' || params[:event][:organizer_id]==nil || params[:event][:organizer_id]=='')
                          @org = Organizer.new
                         
                          @org[:name] = params[:event][:organizer_host]
                          @org[:description] = params[:event][:host_description]
                          @org[:user_id] = session[:user_id]   
                          @org[:event_cnt] = 1
                          @org.save
                          @event[:organizer_id] = @org[:id]
                          
                          @event.save
                          
                    else
                          @organizer = Organizer.find(params[:event][:organizer_id])
                          org_id=@organizer[:id]
                         
                          Organizer.update(params[:event][:organizer_id], :name => params[:org][:organizer_host][org_id.to_s], :description => params[:org][:host_description][org_id.to_s], :event_cnt => @organizer[:event_cnt]+1)
                          
                          @event[:organizer_host] =params[:org][:organizer_host][org_id.to_s]
                          @event[:host_description] =params[:org][:host_description][org_id.to_s]
                          
                          @event.save
                    end     ########   organization ends ##########
                    
                  
                   ########### event repeat section start  ###############   
                   if params[:event_repeat]
                         @eve_repeat = EventRepeat.new
                         @eve_repeat.attributes = params[:event_repeat]
                         @eve_repeat[:event_id] = event_id
                        params[:event_repeat][:event_id]  = event_id
                         
                          if params[:event_repeat_prev_id]!='' && params[:event_repeat_prev_id]!=nil && params[:event_repeat_prev_id]!='0'
                              @everep = EventRepeat.find(params[:event_repeat_prev_id])
                              @everep = @everep.update_attributes(params[:event_repeat])
                          else
                              @everep = @eve_repeat.save
                          end   
                          
                   end      ########   event repeat ends ########## 
                   
                                     
                   ########### tickets section start  ###############
                  if params[:ticket]   
                   
                   if params[:ticket][:free_ticket_id] || params[:ticket][:paid_ticket_id] || params[:ticket][:donation_ticket_id]
                        @all_tickets = Ticket.find(:all, :conditions => ['event_id=?', @event[:id]])
                        
                        
                      if @all_tickets.count > 0
                          
                        for all in @all_tickets
                            chk_id = 0
                            if params[:ticket][:free_ticket_id]
                              if params[:ticket][:free_ticket_id].count > 0
                                  if params[:ticket][:free_ticket_id].include?(all[:id].to_s)
                                      chk_id = 1
                                  end
                              end 
                            end
                              
                            if params[:ticket][:paid_ticket_id]
                              if params[:ticket][:paid_ticket_id].count > 0
                                  if params[:ticket][:paid_ticket_id].include?(all[:id].to_s)
                                      chk_id = 1
                                  end
                              end 
                           end
                            
                          if params[:ticket][:donation_ticket_id]  
                            if params[:ticket][:donation_ticket_id].count > 0
                                if params[:ticket][:donation_ticket_id].include?(all[:id].to_s)
                                    chk_id = 1
                                end
                            end
                         end     
                            
                            if chk_id == 0
                                all.destroy
                            end
                         end
                        
                      end
                   end
                   #### free tickets save
                      
                      @free = params[:ticket][:free_ticket_name]
                      if @free  
                        if @free.count > 0
                          k=0
                          @free.each do |free|
                             
                             
                             
                              @ticket = Ticket.new
                              @ticket[:event_id] = event_id
                              @ticket[:free] = 1
                              @ticket[:free_ticket_name] = params[:ticket][:free_ticket_name][k]
                              @ticket[:free_qty] = params[:ticket][:free_qty][k]
                              @ticket[:free_description] = params[:ticket][:free_description][k]
                              @ticket[:free_min_purchase] = params[:ticket][:free_min_purchase][k]
                              @ticket[:free_max_purchase] = params[:ticket][:free_max_purchase][k]
                              @ticket[:free_start_sale] = params[:ticket][:free_start_sale][k]
                              @ticket[:free_end_sale] = params[:ticket][:free_end_sale][k]
                              @ticket[:free_hide_description] = params[:ticket][:free_hide_description][k]  
                              @ticket[:free_ticket_status] = params[:ticket][:free_ticket_status][k]  
                              
                              @ticket[:paid] = 0
                              @ticket[:donation] = 0
                          
                              
                             
                              if params[:ticket][:free_ticket_id][k]==0 || params[:ticket][:free_ticket_id][k]=='0'
                                    @ticket.save
                              else  
                                    @tic = Ticket.find(params[:ticket][:free_ticket_id][k])
                                    Ticket.update(params[:ticket][:free_ticket_id][k], 
                                        :free_ticket_name => params[:ticket][:free_ticket_name][k], 
                                        :free_qty => params[:ticket][:free_qty][k], 
                                        :free_description => params[:ticket][:free_description][k], 
                                        :free_min_purchase => params[:ticket][:free_min_purchase][k], 
                                        :free_max_purchase => params[:ticket][:free_max_purchase][k], 
                                        :free_start_sale => params[:ticket][:free_start_sale][k], 
                                        :free_end_sale => params[:ticket][:free_end_sale][k], 
                                        :free_hide_description => params[:ticket][:free_hide_description][k], 
                                        :free_ticket_status => params[:ticket][:free_ticket_status][k])
                              end
                              
                               
                              
                              k+=1
                          end
                          
                        end
                      end
                    #### paid tickets save
                      
                        @paid = params[:ticket][:paid_ticket_name]
                      
                      if @paid
                        if @paid.count > 0
                          k=0
                          @paid.each do |paid|
                             
                             
                             
                              @ticket = Ticket.new
                              @ticket[:event_id] = event_id
                              @ticket[:paid] = 1
                              @ticket[:paid_ticket_name] = params[:ticket][:paid_ticket_name][k]
                              @ticket[:paid_qty] = params[:ticket][:paid_qty][k]
                              @ticket[:paid_price] = params[:ticket][:paid_price][k]
                              
                              @ticket[:paid_service_fee] = params[:ticket][:paid_service_fee][k]
                              @ticket[:paid_buyer_total] = params[:ticket][:paid_buyer_total][k]
                              @ticket[:paid_fee] = params[:ticket][:paid_fee][k]
                              
                              @ticket[:paid_description] = params[:ticket][:paid_description][k]
                              @ticket[:paid_min_purchase] = params[:ticket][:paid_min_purchase][k]
                              @ticket[:paid_max_purchase] = params[:ticket][:paid_max_purchase][k]
                              @ticket[:paid_start_sale] = params[:ticket][:paid_start_sale][k]
                              @ticket[:paid_end_sale] = params[:ticket][:paid_end_sale][k]
                              @ticket[:paid_hide_description] = params[:ticket][:paid_hide_description][k]  
                              @ticket[:paid_ticket_status] = params[:ticket][:paid_ticket_status][k] 
                              
                              @ticket[:free] = 0
                              @ticket[:donation] = 0
                          
                               if params[:ticket][:paid_ticket_id][k]==0 || params[:ticket][:paid_ticket_id][k]=='0' 
                                    @ticket.save
                              else  
                                    @tic = Ticket.find(params[:ticket][:paid_ticket_id][k])
                                    Ticket.update(params[:ticket][:paid_ticket_id][k], 
                                        :paid_ticket_name => params[:ticket][:paid_ticket_name][k],
                                        :paid_qty => params[:ticket][:paid_qty][k], 
                                        :paid_price => params[:ticket][:paid_price][k], 
                                        :paid_fee => params[:ticket][:paid_fee][k],
                                        :paid_service_fee => params[:ticket][:paid_service_fee][k], 
                                        :paid_buyer_total => params[:ticket][:paid_buyer_total][k], 
                                        :paid_min_purchase => params[:ticket][:paid_min_purchase][k], 
                                        :paid_max_purchase => params[:ticket][:paid_max_purchase][k],
                                        :paid_start_sale => params[:ticket][:paid_start_sale][k], 
                                        :paid_end_sale => params[:ticket][:paid_end_sale][k], 
                                        :paid_hide_description => params[:ticket][:paid_hide_description][k], 
                                        :paid_ticket_status => params[:ticket][:paid_ticket_status][k])
                              end
                              
                              k+=1
                          end
                        end 
                      end    
                     #### donation tickets save
                      
                        @donation = params[:ticket][:donation_ticket_name]
                      
                      if @donation
                        if @donation.count > 0
                          k=0
                          @donation.each do |donation|
                             
                              @ticket = Ticket.new
                              @ticket[:event_id] = event_id
                              @ticket[:donation] = 1
                              @ticket[:donation_ticket_name] = params[:ticket][:donation_ticket_name][k]
                              @ticket[:donation_qty] = params[:ticket][:donation_qty][k]
                              @ticket[:donation_description] = params[:ticket][:donation_description][k]
                              #@ticket[:donation_min_purchase] = params[:ticket][:donation_min_purchase][k]
                              #@ticket[:donation_max_purchase] = params[:ticket][:donation_max_purchase][k]
                              @ticket[:donation_service_fee] = params[:ticket][:donation_service_fee][k]
                             
                              @ticket[:donation_start_sale] = params[:ticket][:donation_start_sale][k]
                              @ticket[:donation_end_sale] = params[:ticket][:donation_end_sale][k]
                              
                              @ticket[:donation_hide_description] = params[:ticket][:donation_hide_description][k]  
                              @ticket[:donation_ticket_status] = params[:ticket][:donation_ticket_status][k] 
                              
                              @ticket[:paid] = 0
                              @ticket[:free] = 0
                          
                              if params[:ticket][:donation_ticket_id][k]==0 || params[:ticket][:donation_ticket_id][k]=='0'
                                    @ticket.save
                              else  
                                    @tic = Ticket.find(params[:ticket][:donation_ticket_id][k])
                                    Ticket.update(params[:ticket][:donation_ticket_id][k], 
                                        :donation_ticket_name => params[:ticket][:donation_ticket_name][k],
                                        :donation_qty => params[:ticket][:donation_qty][k], 
                                        :donation_description => params[:ticket][:donation_description][k], 
                                        :donation_service_fee => params[:ticket][:donation_service_fee][k],
                                        
                                       # :donation_min_purchase => params[:ticket][:donation_min_purchase][k], 
                                        #:donation_max_purchase => params[:ticket][:donation_max_purchase][k], 
                                        :donation_start_sale => params[:ticket][:donation_start_sale][k], 
                                        :donation_end_sale => params[:ticket][:donation_end_sale][k],
                                        
                                        :donation_hide_description => params[:ticket][:donation_hide_description][k], 
                                        :donation_ticket_status => params[:ticket][:donation_ticket_status][k])
                              end
                              
                              k+=1
                          end 
                        end
                      end    
                   
                  else
                     @all_tickets = Ticket.find(:all, :conditions => ['event_id=?', @event[:id]])
                      for all in @all_tickets
                           all.destroy
                           @event[:event_capacity] = 0
                       end
                    
                   end      ########### tickets section end  ###############   
                      
                   
                    flash[:notice1] = I18n.t 'event_controller.event_details_save_successfully'              
                   
                       if(params[:submit_type]=='save')
                          
                          format.html { redirect_to(:action=>'index' ) }
                          
                       elsif(params[:submit_type]=='view')
                          
                          if @event[:active]==0
                              format.html { redirect_to(:action=>'theme/'+@event[:id].to_s ) }
                          else
                              format.html { redirect_to(:action=>'view/'+@event[:id].to_s ) }
                          end 
                      else
                           @event[:active] = 0
                           flash[:notice1] = I18n.t 'event_controller.event_saved_successfully_submitted' 
                           @event.save
                          
                          UserMailer.make_event_live_request(@event).deliver
                           format.html { redirect_to(:controller => 'manage_event', :action => 'index/'+@event[:id].to_s) }
                       end 
                          
                   
                   format.xml  { render :xml => @event, :status => :created, :location => @event }
                  
                  else
                     flash.now[:notice] = I18n.t 'event_controller.error_creating_try_again'
                     format.html { render :template => 'events/create_event' }
                  end
                  
              end        
        
          else    ########### after post else starts #####
             @event = Event.new(params[:event])
          end   ########### after post ends #####
           
  end
 ########### create_event ends #####
 
 
 
 ########### create_event theme starts #####
 def theme
  @meta_title = I18n.t 'meta_title.event_theme'
   @event = Event.find(params[:id])
   @user = User.find(session[:user_id])
    
    @has = Event.has_rights(@user, @event, 'edit_event')
     
    #if @event[:user_id] == session[:user_id]
    if @has ==1
       session[:event_id] = @event[:id]
       
       lang = Language.find_name(@event[:language_id])
       #set_locale(lang)
    
        if request.post?   ########### after post starts #####
              @event_theme = EventTheme.one_theme(@event[:id])
              
            
             respond_to do |format|
                
                 if @event_theme
                    @event_theme = @event_theme.update_attributes(params[:event_theme])
                 else
                    @event_theme = EventTheme.new(params[:event_theme])
                    @event_theme[:event_id] = @event[:id]
                    @event_theme.save
                 end
                 
                  @event.update_attributes(params[:event])
                 
              #  format.html  { render :template => 'events/create_event_theme' }
                 if(params[:submit_type]=='save')
                      flash[:notice1] = I18n.t 'event_controller.event_design_save_successfully'   
                      format.html { redirect_to(:action=>'index' ) }
                      
                   elsif(params[:submit_type]=='view')
                      if @event[:active]==0
                          format.html { redirect_to(:action=>'theme/'+@event[:id].to_s ) }
                      else
                          format.html { redirect_to(:action=>'view/'+@event[:id].to_s ) }
                      end      
                   else
                       @event[:active] = 0
                       flash[:notice1] = I18n.t 'event_controller.event_saved_successfully_submitted'
                       @event.save
                       UserMailer.make_event_live_request(@event).deliver
                       format.html { redirect_to(:controller => 'manage_event', :action => 'index/'+@event[:id].to_s) }
                   end 
                          
                
             end 
            
        end ########## after post ends #####
       
    else
         flash[:notice] = I18n.t 'event_controller.not_allowed_edit_event_theme'              
         redirect_to(:controller => 'home', :action=>'index' )
    end
    
 end
 
 ########### create_event theme ends #####
 

 ########### edit_event starts #####
  
  def edit
    @meta_title = I18n.t 'meta_title.set_event_title'
     @event = Event.find(params[:id])
    

           @has =  has_action_rights('edit_event')
    
    if @has ==1
        flash[:notice] = I18n.t 'event_controller.not_access_page'        
  redirect_to(:controller => 'home', :action=>'index' ) and return # else redirect to reffered events
 #    else
        # This will solve double redirect error 
    end 

     
    if @event[:user_id] == session[:user_id] || @event[:user_id] == @user[:ref_id]
       session[:event_id] = @event[:id]
        
       
       respond_to do |format|
            format.html  { render :template => 'events/create_event' }
       end 
    else
         flash[:notice] = I18n.t 'event_controller.not_access_page'        
         redirect_to(:controller => 'home', :action=>'index' )
    end
    
  end
  
  ########### edit_event ends #####
  
   
############### view event details start ##################

  def view
     
     @site = SiteSetting.find(:first)
     
     if(params[:id])
        @event = Event.find(params[:id])
     else
        @event = Event.find(session[:event_id])
     end  
  
  
     
    if session[:user_id]!=@event[:user_id] &&  @event[:active]!=1
     flash[:notice] = I18n.t 'event_controller.not_allowed_view_event'              
     redirect_to(:controller => 'home', :action=>'index' )

  
   else
     
     lang = Language.find_name(@event[:language_id])
     set_locale(lang)
     @meta_title = @event[:event_title]#I18n.t 'meta_title.event_view'
     @meta_keyword = @event[:event_title].gsub(" ", ",")
     @meta_desc = @event[:event_title]+ ' -- '+@event[:event_start_date_time].strftime('%A, %B %d, %Y').to_s+' -- '+@event[:organizer_host]
     
     @promo = ''
     @code_type = 0
     @promo_code_id = 0
     
    # session[:event_password] = ""
     
     if params[:event_password] && params[:event_password]!=''
          session[:event_password] = params[:event_password]       
     end
     
     if params[:promo] && params[:promo]!=''
     flash[:notice] = ""
     #@promo_code = PromotionalCode.find(:first, :conditions => ['code=?',params[:promo]])
      @disc_codes = PromotionalCode.find(:first, :conditions => ['code=? AND code_type=? AND event_id=?', params[:promo], 'disc', @event[:id]])
      @access_codes = PromotionalCode.find(:first, :conditions => ['code=? AND code_type=? AND event_id=?',params[:promo], 'access', @event[:id]])
      
        # if @promo_code
        if @disc_codes 
            @code_type = 1
           # flash[:notice] = ""
            
         elsif @access_codes
            @code_type = 2
           # flash[:notice] = ""
         else
           
            flash[:notice] = I18n.t 'validation.event_view.not_promo'  
         end  
         
         
     end
     @org_id = @event[:organizer_id]
     
     if session[:user_id]==nil || session[:user_id]=='' || session[:user_id]!=@event[:user_id]
        Event.update_all(['page_visits=?', @event[:page_visits]+1],['id=?',@event[:id]])
     end
      
     @event_theme = EventTheme.one_theme(@event[:id])
     if @event_theme
     else @event_theme = Theme.find_first_theme
     end     
     
     @updates = EventUpdate.find(:all, :conditions => ['event_id=?', @event[:id]])
     @one_theme = @event_theme
     render :layout => 'application_login'
     
    end
    
      
  end

  
  def custom_url
  
  # ret_url = request.url 
  # @msg = '?err=redirect' 
  # if (ret_url.include? @msg )
  #    params[:promo] = ""
  #    flash[:notice] = I18n.t 'event.view.redirect_err'
  # end
     
 
     @site = SiteSetting.find(:first)
    
     if(params[:id])
        @event = Event.find(:first, :conditions => ['event_url_link=?',params[:id]])
     else
        @event = Event.find(session[:event_id])
     end  
     
   if session[:user_id]!=@event[:user_id] &&  @event[:active]!=1
     flash[:notice] = I18n.t 'event_controller.not_allowed_view_event'              
     redirect_to(:controller => 'home', :action=>'index' )
  
   else
     
     lang = Language.find_name(@event[:language_id])
     set_locale(lang)
     @meta_title = @event[:event_title]#I18n.t 'meta_title.event_view'
     @meta_keyword = @event[:event_title].gsub(" ", ",")
     @meta_desc = @event[:event_title]+ ' -- '+@event[:event_start_date_time].strftime('%A, %B %d, %Y').to_s+' -- '+@event[:organizer_host]
     
     @promo = ''
     @code_type = 0
    # @promo_code_id = 0
    
    #session[:event_password] = ""
     
     if params[:event_password] && params[:event_password]!=''
          session[:event_password] = params[:event_password]       
     end
     
     if params[:promo] && params[:promo]!=''
     
      flash[:notice] = ""
      #@promo_code = PromotionalCode.find(:first, :conditions => ['code=?',params[:promo]])
      @disc_codes = PromotionalCode.find(:first, :conditions => ['code=? AND code_type=? AND event_id=?', params[:promo], 'disc', @event[:id]])
      @access_codes = PromotionalCode.find(:first, :conditions => ['code=? AND code_type=? AND event_id=?',params[:promo], 'access', @event[:id]])
   
    
        # if @promo_code
        if @disc_codes 
            @code_type = 1
           # flash[:notice] = ""
            
         elsif @access_codes 
            @code_type = 2
          #  flash[:notice] = ""
         else
           
            flash[:notice] = I18n.t 'validation.event_view.not_promo'  
         end 
     end
     
     @org_id = @event[:organizer_id]
     
     if session[:user_id]==nil || session[:user_id]=='' || session[:user_id]==@event[:user_id]
        Event.update_all(['page_visits=?', @event[:page_visits]+1],['id=?',@event[:id]])
     end
      
     @event_theme = EventTheme.one_theme(@event[:id])
     if @event_theme
     else @event_theme = Theme.find_first_theme
     end
     
     @updates = EventUpdate.find(:all, :conditions => ['event_id=?', @event[:id]])
     @one_theme = @event_theme
     render :layout => 'application_login', :template => 'events/view'
     
     end
  end
############### view event details end ##################



  
  def event_display_attendee
   @event = Event.find(params[:id])
   @event_attendee = Attendee.one_attendee(@event[:id])
   if @event_attendee   
   else
      @event_attendee = Attendee.new
   end        
        if request.post?   ########### after post starts #####
           
             respond_to do |format|
                 @event_attendee = Attendee.one_attendee(@event[:id])
              
                 if @event_attendee
                    @event_attendee = @event_attendee.update_attributes(params[:event_attendee])
                 else
                    @event_attendee = Attendee.new(params[:event_attendee])
                    @event_attendee[:event_id] = @event[:id]
                    @event_attendee.save
                 end
                
             end 
            
        end ########## after post ends #####
         render :layout => false      
  end
  
  
  
  def subcategory_selection
       @subcategory = Category.sub_category_by_parent(params[:category])
       respond_to do |format|
         format.html  { render :layout => false }
       end 
  end
  
 
  def change_event_theme
     @one_theme = Theme.find(params[:theme_id])
    
     respond_to do |format|
         format.html  { render :template => 'events/_change_event_theme', :layout => false }
     end 
     
  end


  def event_theme_page
     @event = Event.find(params[:event_id])
     lang = Language.find_name(@event[:language_id])
     set_locale(lang)
     #@meta_title = I18n.t 'meta_title.event_view'
     
     @one_theme = Theme.find(params[:theme_id])
     respond_to do |format|
         format.html  { render :template => 'events/_event_theme_page', :layout => false }
     end 
     
  end

  def uploading
   post = Event.saveimage(params[:upload])
   render :json => { :success => true, :msg => { :image => post.as_json(), :error => '', :success => ''}  } 
  end


  def event_url_link
    @event = Event.find(:first, :conditions => ['event_url_link=?',params[:val]])
   
     if @event
         render :json => { :success => true, :msg => (I18n.t 'event_controller.url_already_taken')}
     else
       render :json => { :success => true, :msg => (I18n.t 'contact_controller.success')  }
       
     end  
       
  end
  
  
  
  def save_event
    @event = Event.find(params[:id])
     lang = Language.find_name(@event[:language_id])
     set_locale(lang)
     
    if @event
          if @event[:user_id]==session[:user_id]
              msg = (I18n.t 'validation.event_view.can_not_save_own_event')      
          else
              @cnt = SaveEvent.find(:all, :conditions => ['user_id=? AND event_id=?', session[:user_id], @event[:id]]).count
              
              if @cnt > 0 
                  msg = (I18n.t 'validation.event_view.already_saved')       
              else  
                  @evesave = SaveEvent.new
                  @evesave[:user_id] = session[:user_id]
                  @evesave[:event_id] = @event[:id]
                  
                   if @evesave.save
                        msg = (I18n.t 'contact_controller.success')
                    else
                        msg = @evesave.errors.full_messages[0]  
                    end 
                  
                  
              end  
          end
    else
         msg = (I18n.t 'validation.event_view.event_not_exists')           
         
    end
   
    render :json => { :success => true, :msg => msg}
    
  end
  
end