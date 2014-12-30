class ManageEventController < ApplicationController
  before_filter :authorize, :except => [:download_excel]
  before_filter :event_authorize, :except => [:delete_que, :edit_news_and_updates, :delete_update, :delete_code, :edit_order, :edit_code, :edit_affiliate_code, :delete_affiliate_codes, :copy, :org_url_link, :download_excel, :custombutton]
  
  #########  Event Dashboard Page
  def index
      @meta_title = I18n.t 'meta_title.m_dashboard'
      @user = User.find(session[:user_id])
      @site = SiteSetting.find(:first)
      @event = Event.find(params[:id])
      @orders = Purchase.find_orders_by_event(@event[:id])
      @event_attendee = EventAttendee.find(:all, :conditions => ['event_id=?', @event[:id]])
  end
  
  
  def widget_info
   
    @event = Event.find(params[:id])

    @widget = Widget.new
      @widget[:widget_text] = params[:widgetText]
      @widget[:text_color] = params[:text_color]
      @widget[:back_color] = params[:back_color]
      @widget[:widget_size] = params[:widget_size]
      @widget[:event_id] = @event[:id]
     
     @widget.save
  
    respond_to do |format|
      format.html  { render :layout => false }
    end        
  end
  
  def custombutton
      
      @widget = Widget.find(:last)
         
    respond_to do |format|
      format.html  { render :layout => false }
    end
  end
  
  def customform
         
    respond_to do |format|
      format.html  { render :layout => false }
    end
  end
  
  def download_excel
     @event = Event.find(params[:id])
     @orders = Purchase.find_orders_by_event_total(@event[:id])
     respond_to do |format|
        #format.xls# { send_data @products.to_csv(col_sep: "\t") }
         filename = @event[:event_title]+".xls"
         format.xls{ headers["Content-Disposition"] = "attachment; filename=\"#{filename}\"" }
      
     end
  end
  
  
  ######## Customize Order Form
  def customize_order_form
      @meta_title = I18n.t 'meta_title.m_customize_order_form'
      @user = User.find(session[:user_id])
      @site = SiteSetting.find(:first)
      @event = Event.find(params[:id])
      @questions = Question.find(:all, :conditions => ['event_id=?', @event[:id]]) 
     

       eact = 'custom_register'
	    @has_order = Event.has_rights(@user, @event, eact) 
	    
	     if @has_order != 1 
	       flash[:notice] = I18n.t 'event_controller.not_access_page'        
	       redirect_to(:controller => 'home', :action=>'index' ) and return # else redirect to reffered events
	     end
     
      if request.post?
          
              
                  if params[:ticket]
                      params[:order_form][:tickets] = params[:ticket].join(',')
                  end    
                  
                  if params[:prefix]
                      params[:order_form][:prefix] = params[:prefix].join(',').gsub(',','') 
                  end
                  
                  if params[:first_name]    
                      params[:order_form][:first_name] = params[:first_name].join(',').gsub(',','')
                  end
                  
                  if params[:last_name]      
                      params[:order_form][:last_name] = params[:last_name].join(',').gsub(',','')
                  end
                  
                  if params[:suffix]      
                      params[:order_form][:suffix] = params[:suffix].join(',').gsub(',','')
                  end
                  
                  if params[:email]      
                      params[:order_form][:email] = params[:email].join(',').gsub(',','')
                  end
                  
                  if params[:home_phone]      
                      params[:order_form][:home_phone] = params[:home_phone].join(',').gsub(',','')
                  end
                  
                  if params[:cell_phone]      
                      params[:order_form][:cell_phone] = params[:cell_phone].join(',').gsub(',','') 
                  end
                  
                  if params[:billing_address]     
                      params[:order_form][:billing_address] = params[:billing_address].join(',').gsub(',','') 
                  end
                  
                  if params[:home_address] 
                      params[:order_form][:home_address] = params[:home_address].join(',').gsub(',','') 
                  end
                  
                  if params[:shipping_address] 
                      params[:order_form][:shipping_address] = params[:shipping_address].join(',').gsub(',','') 
                  end
                  
                  if params[:job_title] 
                      params[:order_form][:job_title] = params[:job_title].join(',').gsub(',','') 
                  end
                  
                  if params[:company] 
                      params[:order_form][:company] = params[:company].join(',').gsub(',','') 
                  end
                  
                  if params[:work_address] 
                      params[:order_form][:work_address] = params[:work_address].join(',').gsub(',','') 
                  end
                  
                  if params[:work_phone] 
                      params[:order_form][:work_phone] = params[:work_phone].join(',').gsub(',','') 
                  end
                  
                  if params[:website] 
                      params[:order_form][:website] = params[:website].join(',').gsub(',','') 
                  end
                  
                  if params[:blog] 
                      params[:order_form][:blog] = params[:blog].join(',').gsub(',','') 
                  end
                  
                  if params[:gender] 
                      params[:order_form][:gender] = params[:gender].join(',').gsub(',','') 
                  end
                  
                  if params[:birth_date] 
                      params[:order_form][:birth_date] = params[:birth_date].join(',').gsub(',','') 
                  end
                  
                  if params[:age] 
                      params[:order_form][:age] = params[:age].join(',').gsub(',','') 
                  end
                  
                  if(params[:order_id]==nil || params[:order_id]=='')
                       @order_form = OrderForm.new(params[:order_form])
                       @order_form.save
                  else
                       @order_form = OrderForm.find(params[:order_id])
                       @order_form.update_attributes(params[:order_form])  
                  end 
              
                  if @questions.count > 0
                    for q in @questions
                        @que_id = params[:que_id]
                        if @que_id
                            if(@que_id.include?(q[:id].to_s))
                               if params[:que] && params[:que].count>0
                                  if params[:que][q[:id].to_s]
                                    q[:rules] = params[:que][q[:id].to_s].join(',').gsub(',','')
                                    q.save 
                                  end
                               end   
                            else
                                QuestionOption.destroy_all("que_id = "+q[:id].to_s)
                                Answer.destroy_all("que_id = "+q[:id].to_s)
                                q.destroy
                            end  
                        end
                    end
                  end
                  
                  flash[:notice1] = I18n.t 'manage_event_controller.info_save_successfully'
                  redirect_to(:action=>'customize_order_form')
          
     
     end       
  end
  
  
  ######## Add Custom Questions
 def question
      @meta_title = I18n.t 'meta_title.m_que_for_event'
      @user = User.find(session[:user_id])
      @site = SiteSetting.find(:first)
      @event = Event.find(params[:id])
      
           eact = 'custom_register'
	    @has_order = Event.has_rights(@user, @event, eact) 
	    
	     if @has_order != 1 
	       flash[:notice] = I18n.t 'event_controller.not_access_page'        
	       redirect_to(:controller => 'home', :action=>'index' ) and return # else redirect to reffered events
	     end
      
      if(params[:order_form]!='' && params[:order_form]!=nil && params[:order_form]!='0')
       @que = Question.new()
       cust_ord_form()
      else
          if(params[:que_id]!='' && params[:que_id]!=nil && params[:que_id]!='0')
            @que = Question.find(params[:que_id])
          else
            @que = Question.new(params[:que])
          end
     # end
          
      if request.post?
           respond_to do |format|

		if(params[:que_id]!='' && params[:que_id]!=nil && params[:que_id]!='0')
		          @que.update_attributes(params[:que])
		          flash[:notice1] = I18n.t 'manage_event_controller.que_added_order_update'
		       	  format.html { redirect_to(:action=>'customize_order_form/'+params[:id].to_s) }   
		else
		       if @que.save
		       flash[:notice1] = I18n.t 'manage_event_controller.que_added_order_successfully'
                       format.html { redirect_to(:action=>'customize_order_form/'+params[:id].to_s) }
		       else
		       flash[:notice1] = I18n.t 'manage_event_controller.que_added_order_error'
               	       format.html { redirect_to(:action=>'customize_order_form/'+params[:id].to_s) }
		       end
		      #  @que = Question.new(params[:que])
		end
		 

              
             # @que.save
              
              if(@que[:que_type]=='check' || @que[:que_type]=='select' || @que[:que_type]=='radio')
                  
                  @all_opt = QuestionOption.find(:all, :conditions => ['que_id=?', @que[:id]])
                        
                        
                      if @all_opt.count > 0
                          
                        for all in @all_opt
                            chk_id = 0
                            if params[:que_opt_id]
                              if params[:que_opt_id].count > 0
                                  if params[:que_opt_id].include?(all[:id].to_s)
                                      chk_id = 1
                                  end
                              end 
                            end
                            
                            if chk_id == 0
                                all.destroy
                            end
                         end
                        
                      end
                   
                   #### options save
                      
                      @opt = params[:que_value]
                      if @opt  
                        if @opt.count > 0
                          k=0
                          @opt.each do |opt|
                             
                             if(params[:que_opt_id][k]==0 || params[:que_opt_id][k]=='0')
                                  @que_opt = QuestionOption.new
                                  @que_opt[:que_id] = @que[:id]
                                  @que_opt[:qty] = params[:que_qty][k]
                                  @que_opt[:value] = params[:que_value][k]
                                  @que_opt.save
                              else  
                                  @que_opt = QuestionOption.find(params[:que_opt_id][k])
                                  @que_opt[:que_id] = @que[:id]
                                  @que_opt[:qty] = params[:que_qty][k]
                                  @que_opt[:value] = params[:que_value][k]
                                  @que_opt.save
                              end
                              
                              k+=1
                          end
                          
                        end
                      end
                      
              end
                
              if @que[:spec_ticket]==1
                  if params[:tickets]      
                      @que[:tickets] = params[:tickets].join(',')
                      @que.save
                  end
              end
              
              if @que[:que_type]=='waiver'
                 if(params[:waiv_id]==0 || params[:waiv_id]=='0')
                      @que_opt = QuestionOption.new
                      @que_opt[:que_id] = @que[:id]
                      @que_opt[:value] = params[:que_waiv]
                      @que_opt.save
                  else  
                      @tic = QuestionOption.find(params[:waiv_id])
                      @que_opt[:que_id] = @que[:id]
                      @que_opt[:value] = params[:que_waiv]
                      @que_opt.save 
                  end
              end  
              #flash[:notice1] = I18n.t 'manage_event_controller.que_added_order_successfully'
              #format.html { redirect_to(:action=>'customize_order_form/'+params[:id].to_s) }
           end
     end 
   end
 
 end
 
 
 def delete_que
    q = Question.find(params[:id])
    event_id = q[:event_id]
    
     @user = User.find(session[:user_id])
      @event = Event.find(event_id)
      
      eact = 'custom_register'
    @has_order = Event.has_rights(@user, @event, eact) 
    
     if @has_order != 1 
       flash[:notice] = I18n.t 'event_controller.not_access_page'        
       redirect_to(:controller => 'home', :action=>'index' ) and return # else redirect to reffered events
     end
      
    
    QuestionOption.destroy_all("que_id = "+q[:id].to_s)
    Answer.destroy_all("que_id = "+q[:id].to_s)
    q.destroy
    flash[:notice1] = I18n.t 'manage_event_controller.que_deleted_order_successfully'
    redirect_to(:action=>'customize_order_form/'+event_id.to_s)
 end  
  
  
  ######## Confirm Customize Order Form
  def edit_order_confirmation
      @meta_title = I18n.t 'meta_title.m_edit_order_confirmation'
      @user = User.find(session[:user_id])
      @site = SiteSetting.find(:first)
      @event = Event.find(params[:id])
      
     
      eact = 'custom_register'
    @has_order = Event.has_rights(@user, @event, eact) 
	    
     if @has_order != 1 
       flash[:notice] = I18n.t 'event_controller.not_access_page'        
       redirect_to(:controller => 'home', :action=>'index' ) and return # else redirect to reffered events
     end
      
      if request.post?
          
           respond_to do |format|
               
                  if(params[:order_id]==nil || params[:order_id]=='')
                       @order_form = OrderForm.new(params[:order_form])
                       @order_form.save
                  else
                       @order_form = OrderForm.find(params[:order_id])
                       @order_form.update_attributes(params[:order_form])  
                  end 
                  
                  flash[:notice1] = I18n.t 'manage_event_controller.info_save_successfully'
                  format.html { redirect_to(:action=>'edit_order_confirmation') }
          end
     
     end       
  end
  
 ######## Event type and language
 def type_and_language
      @meta_title = I18n.t 'meta_title.m_edit_type_language'
      @user = User.find(session[:user_id])
      @site = SiteSetting.find(:first)
      @event = Event.find(params[:id])
      
      lang = Language.find_name(@event[:language_id])
      #set_locale(lang)
    
      if request.post?
          
           respond_to do |format|
               
                 @event.update_attributes(params[:event])  
                  
                  flash[:notice1] = I18n.t 'manage_event_controller.info_save_successfully'
                  format.html { redirect_to(:action=>'type_and_language') }
          end
     
     end   
 end
 
  ######## News and updates
 def news_and_updates
      @meta_title = I18n.t 'meta_title.m_add_news_updates'
      @user = User.find(session[:user_id])
      @site = SiteSetting.find(:first)
      @event = Event.find(params[:id])
 end
 
 
 def edit_news_and_updates
     if request.post?
          
           respond_to do |format|
                 if(params[:event_update][:updates]=='' || params[:event_update][:updates]=='&nbsp;')
                      flash[:notice] = I18n.t 'manage_event_controller.update_is_required' 
                 else
                   if(params[:update_id]=='0')
                       @eveupdates = EventUpdate.new
                       @eveupdates[:updates] = params[:event_update][:updates]
                       @eveupdates[:event_id] = params[:event_update][:event_id]
                       
                       @eveupdates.save
                       flash[:notice1] = I18n.t 'manage_event_controller.update_added_successfully'
                   else  
                       @eveupdates = EventUpdate.find(params[:update_id])
                       @eveupdates.update_attributes(params[:event_update])
                       flash[:notice1] = I18n.t 'manage_event_controller.update_updated_successfully'  
                   end
                 end
                   format.html { redirect_to(:action=>'news_and_updates/'+params[:event_update][:event_id]) }
          end
     
     end   
 end
 
 def delete_update
       respond_to do |format|
               @update = EventUpdate.find(params[:id])
               @update.destroy  
                
               flash[:notice1] = I18n.t 'manage_event_controller.update_delete_successfully'
               format.html { redirect_to(:action=>'news_and_updates/'+params[:eve]) }
        end
    
 end
 
 ######## Google Analytics
 
   #Method Name :google_analytic_code
   #Parameter : Id , Event 
   #Return : 
   #Use : Enter Google Analytic Code And Store Event Table. open your Google Account to Check event summary report 
   
 ########
 
 def google_analytic_code
      @meta_title = I18n.t 'meta_title.m_google_analytics'
      @user = User.find(session[:user_id])
      @site = SiteSetting.find(:first)
      @event = Event.find(params[:id])
      if request.post?
           respond_to do |format|
              @event.update_attributes(params[:event])  
              flash[:notice1] = I18n.t 'manage_event_controller.google_analytics_saved_successfully'
              format.html { redirect_to(:action=>'google_analytic_code') }
           end
     end 
 end
 
 
  #########  Orders Page
  def orders 
      @meta_title = I18n.t '.meta_title.m_orders'
      @user = User.find(session[:user_id])
      @site = SiteSetting.find(:first)
      @event = Event.find(params[:id])
      
      eact = 'view_orders'
	    @has_order = Event.has_rights(@user, @event, eact) 
	    
	     if @has_order != 1 
	       flash[:notice] = I18n.t 'event_controller.not_access_page'        
	       redirect_to(:controller => 'home', :action=>'index' ) and return # else redirect to reffered events
	     end
      
     # query = 'event_id='+@event[:id].to_s+' AND ticket_id>0 AND payment=1'
       query = 'event_id='+@event[:id].to_s+' AND payment=1'
       
      #@orders = Purchase.where('event_id=? AND (ticket_id=0 or ticket_id=null) ' , @event[:id])
      order_by = 'order by id DESC'
      per_page = 5
      
      
        ### date range
        if params[:date_range]=='week'
            time = Time.new
            day = time.wday
            eday = 6 - day
           query = query + ' AND DATE(created_at) between "'+(Date.today - day.days).strftime('%Y-%m-%d').to_s+'" and "'+(Date.today + eday.days).strftime('%Y-%m-%d').to_s+'"'
           #@orders = Purchase.where("event_id=? AND (ticket_id=0 or ticket_id=null) AND DATE(created_at) between ? and ?  ", @event[:id], Date.today - day.days, Date.today + eday.days) 
        elsif params[:date_range]=='month'
           query = query + ' AND MONTH(created_at)="'+(DateTime.now.strftime('%m')).to_s+'"'
           #@orders = Purchase.where("event_id=? AND (ticket_id=0 or ticket_id=null) AND MONTH(created_at)=? ", @event[:id], DateTime.now.strftime('%m'))
        elsif params[:date_range]=='year'  
          query = query + ' AND YEAR(created_at)= "'+(DateTime.now.strftime('%Y')).to_s+'"'
          #@orders = Purchase.where("event_id=? AND (ticket_id=0 or ticket_id=null)  AND YEAR(created_at)=? ", @event[:id], DateTime.now.strftime('%Y'))
        elsif params[:date_range]=='custom'    
           if params[:start_date]!=nil && params[:start_date]!='' && params[:end_date]!=nil && params[:end_date]!=''
              query = query + ' AND DATE(created_at) between "'+params[:start_date]+'" and "'+params[:end_date]+'"' 
              #@orders = Purchase.where("event_id=? AND (ticket_id=0 or ticket_id=null)  AND DATE(created_at) between ? and ? ", @event[:id], params[:start_date], params[:end_date])
           end   
        end
         @date_range=params[:date_range]
        
        ####  name,email,company, job title, blog
        if params[:search]!='' && params[:search]!=nil
           query = query + ' AND (first_name like "%'+params[:search]+'%" or last_name like "%'+params[:search]+'%" or id like "%'+params[:search]+'%" or work_company like "%'+params[:search]+'%" or work_job_title like "%'+params[:search]+'%" or work_blog like "%'+params[:search]+'%" or email like "%'+params[:search]+'%")'
  
        end
          @search= params[:search]
        
        ####  order asc - desc
        
        if params[:sort_by]=='date_desc'
              order_by = 'order by created_at DESC'
        elsif params[:sort_by]=='date_asc'
              order_by = 'order by created_at ASC'
        elsif params[:sort_by]=='email_asc'
              order_by = 'order by email ASC'
        elsif params[:sort_by]=='email_desc'
              order_by = 'order by email DESC'
        elsif params[:sort_by]=='amt_asc'
              order_by = 'order by total ASC'
        elsif params[:sort_by]=='amt_desc'  
              order_by = 'order by total DESC'
        end
        @sort_by=params[:sort_by]
        
        #######  per page
        per_page = params[:per_page]
        #@orders = Purchase.paginate(:page => params[:page], :per_page => params[:per_page])
        @per_page = params[:per_page]
       
         @orders = Purchase.find_by_sql('select * from purchases where '+query+' '+order_by).paginate(:page => params[:page], :per_page => per_page)
         @orders_xls = Purchase.find_by_sql('select * from purchases where '+query+' '+order_by)
      
  end
  
  def edit_order
  
   
	     
    if params[:id]
      
          @meta_title = I18n.t '.meta_title.m_edit_orders'
          @user = User.find(session[:user_id])
          @site = SiteSetting.find(:first)
          @order = Purchase.find(params[:id])
          
          
       if Event.exists?(@order[:event_id])   
          @event = Event.find(@order[:event_id])
          
            eact = 'manage_order'
	    @has_order = Event.has_rights(@user, @event, eact) 
	    
	     if @has_order != 1 
	       flash[:notice] = I18n.t 'event_controller.not_access_page'        
	       redirect_to(:controller => 'home', :action=>'index' ) and return # else redirect to reffered events
	     end
	     
          @questions = Question.find(:all, :conditions => ['event_id=?', @event[:id]]) 
          
          if request.post?
             @order.update_attributes(params[:order])
             
             flash[:notice1] = I18n.t 'manage_event_controller.order_info_updated_successfully'
             redirect_to(:action=>'orders/'+@order[:event_id].to_s) 
          end
      else
        redirect_to :controller => 'events' 
      end      
    else
      redirect_to :controller => 'events'  
    end
  end
 
 ######## Waitlist Settings
 def waitlist_setting
      @meta_title = I18n.t '.meta_title.m_waitlist_setting'
      @user = User.find(session[:user_id]) 
      @site = SiteSetting.find(:first)
      @event = Event.find(params[:id])
      if request.post?
           respond_to do |format|
                  if(params[:list_id]==nil || params[:list_id]=='')
                       @list = Waitlist.new(params[:waitlist])
                       @list.save
                  else
                       @list = Waitlist.find(params[:list_id])
                       @list.update_attributes(params[:waitlist])  
                  end 
                flash[:notice1] = I18n.t 'manage_event_controller.waitlist_settings_saved_successfully'
                format.html { redirect_to(:action=>'waitlist_setting') }
          end
     end 
 end
 
 
 
 ######## Promotional Codes
 def promotional_codes
      @meta_title = I18n.t '.meta_title.m_promotional_codes'
      @user = User.find(session[:user_id])
      @site = SiteSetting.find(:first)
      @event = Event.find(params[:id])
      
       eact = 'manage_discount'
             @has_discount = Event.has_rights(@user, @event, eact)
      
        if @has_discount != 1 
	       flash[:notice] = I18n.t 'event_controller.not_access_page'        
	       redirect_to(:controller => 'home', :action=>'index' ) and return # else redirect to reffered events
	     end
      
      @disc_codes = PromotionalCode.find(:all, :conditions => ['event_id=? AND code_type=?',@event[:id], 'disc'])
      @access_codes = PromotionalCode.find(:all, :conditions => ['event_id=? AND code_type=?',@event[:id], 'access'])
      if(@disc_codes.count > 0 || @access_codes.count > 0)
          render :template => 'manage_event/list_promotional_codes'
      else
          @code = PromotionalCode.new
          render :template => 'manage_event/add_promotional_codes'
      end    
        
 end
 
 def import
     PromotionalCode.import(params[:upload_doc], @event[:id],@code[:code_type])
      redirect_to root_url, :notice => (I18n.t 'contact_controller.products_imported')
    end
 
 def edit_code
    #validate_event_user(params[:id])
    @meta_title = I18n.t '.meta_title.m_edit_promotional_code'
    @user = User.find(session[:user_id])
    @site = SiteSetting.find(:first)
    @event = Event.find(params[:id])
    
   eact = 'manage_discount'
     @has_discount = Event.has_rights(@user, @event, eact)

if @has_discount != 1 
       flash[:notice] = I18n.t 'event_controller.not_access_page'        
       redirect_to(:controller => 'home', :action=>'index' ) and return # else redirect to reffered events
     end
    
    if request.post?
           respond_to do |format|
                  
                  params[:code][:tickets]= params[:ticket].join(',')
                  if params[:code_use]=='0'
                     params[:code][:uses] = 0
                  else
                     params[:code][:uses] = params[:uses] 
                  end
                  
                  
                  if(params[:code_id]==nil || params[:code_id]=='')
                    
                    if (params[:enter_code] == "0") # Enter code manually
                          @code = PromotionalCode.new(params[:code])
                          @code.save
                          
                            if @code.save
                                 flash[:notice1] = I18n.t 'manage_event_controller.promotional_code_added_successfully'
                                 format.html { redirect_to(:action=>'promotional_codes/'+@event[:id].to_s) }
                            else
                                 format.html { render :action => "edit_code", :template => 'manage_event/add_promotional_codes'}
                                 format.xml  { render :xml => @code.errors, :status => :unprocessable_entity }
                            end
                           
                    else
                              @code = PromotionalCode.new(:code => params[:code])
                              @code[:code_type] = params[:code][:code_type] # code_type = 'disc' or 'access'
                             
                              PromotionalCode.import(params[:upload_doc], @event[:id],@code[:code_type])  
                              
                              flash[:notice1] = I18n.t 'manage_event_controller.promotional_code_may_already_exist'
                              format.html { redirect_to(:action=>'promotional_codes/'+@event[:id].to_s) } 
                    end
                       
                        
                  else # if params[:code_id] exists...
                        @code = PromotionalCode.find(params[:code_id])
                       
                        if @code.update_attributes(params[:code]) 
                              flash[:notice1] = I18n.t 'manage_event_controller.promotional_code_updated_successfully'
                              format.html { redirect_to(:action=>'promotional_codes/'+@event[:id].to_s) }
                        else
                             
                             format.html { render :action => "edit_code", :template => 'manage_event/add_promotional_codes' }
                             format.xml  { render :xml => @code.errors, :status => :unprocessable_entity }
                        end 
                  end 
               
          end
     else
        
        if params[:code_id] 
          @code = PromotionalCode.find(params[:code_id])
        else  
          @code = PromotionalCode.new
        end  
        render :template => 'manage_event/add_promotional_codes'
     end 
 end
 
 
 
 def delete_code
 
    @user = User.find(session[:user_id])
    @event = Event.find(params[:id])
    
   eact = 'manage_discount'
     @has_discount = Event.has_rights(@user, @event, eact)

if @has_discount != 1 
       flash[:notice] = I18n.t 'event_controller.not_access_page'        
       redirect_to(:controller => 'home', :action=>'index' ) and return # else redirect to reffered events
     end
 
   respond_to do |format|
         @code = PromotionalCode.find(params[:code_id])
         @code.destroy
         
        flash[:notice1] = I18n.t 'manage_event_controller.promotional_code_deleted_successfully'
        format.html { redirect_to(:action=>'promotional_codes/'+params[:id].to_s) }
   end
 end
 
 
 
 
 ######## Affiliate Codes
 def affiliate_codes
      @meta_title = I18n.t '.meta_title.affiliate_programs'
      @user = User.find(session[:user_id])
      @site = SiteSetting.find(:first)
      @event = Event.find(params[:id])
      
    
   eact = 'manage_affiliate'
     @has_affiliate = Event.has_rights(@user, @event, eact)

     if @has_affiliate != 1 
       flash[:notice] = I18n.t 'event_controller.not_access_page'        
       redirect_to(:controller => 'home', :action=>'index' ) and return # else redirect to reffered events
     end
      
      @affiliates = Affiliate.find(:all, :conditions => ['event_id=? ', @event[:id]])
      
      @visit = Affiliate.sum(:visits, :conditions => ['event_id=? ', @event[:id]])
      @affiliate = Affiliate.sum(:affiliates, :conditions => ['event_id=? ', @event[:id]])
      @sales = Affiliate.sum(:sales, :conditions => ['event_id=? ', @event[:id]])
      @due = Affiliate.sum(:due, :conditions => ['event_id=? ', @event[:id]])
      @paid = Affiliate.sum(:paid, :conditions => ['event_id=? ', @event[:id]])
      
      if(@affiliates.count > 0)
          render :template => 'manage_event/list_affiliate_codes'
      else
          @code = Affiliate.new
          render :template => 'manage_event/add_affiliate_codes'
      end    
        
 end
 
 
 def edit_affiliate_code
    @meta_title = I18n.t '.meta_title.edit_affiliate_code'
    @user = User.find(session[:user_id])
    @site = SiteSetting.find(:first)
    @event = Event.find(params[:id])
    
      eact = 'manage_affiliate'
     @has_affiliate = Event.has_rights(@user, @event, eact)

     if @has_affiliate != 1 
       flash[:notice] = I18n.t 'event_controller.not_access_page'        
       redirect_to(:controller => 'home', :action=>'index' ) and return # else redirect to reffered events
     end
    
   if request.post?
           respond_to do |format|
                  
                  if(params[:code_id]==nil || params[:code_id]=='')
                      
                           @code = Affiliate.new(params[:code])
                           @code[:user_id] = @user[:id]
                            if @code.save
                                 flash[:notice1] = I18n.t 'manage_event_controller.affiliate_code_added_successfully'
                                 format.html { redirect_to(:action=>'affiliate_codes/'+@event[:id].to_s) }
                            else
                                 format.html { render :action => "edit_affiliate_code", :template => 'manage_event/add_affiliate_codes'}
                                 format.xml  { render :xml => @code.errors, :status => :unprocessable_entity }
                            end
                       
                  else
                        @code = Affiliate.find(params[:code_id])
                       
                        if @code.update_attributes(params[:code]) 
                              flash[:notice1] = I18n.t 'manage_event_controller.affiliate_code_updated_successfully'
                              format.html { redirect_to(:action=>'affiliate_codes/'+@event[:id].to_s) }
                        else
                             
                             format.html { render :action => "edit_affiliate_code", :template => 'manage_event/add_affiliate_codes' }
                             format.xml  { render :xml => @code.errors, :status => :unprocessable_entity }
                        end 
                  end 
               
          end
     else
        
        if params[:code_id] 
          @code = Affiliate.find(params[:code_id])
        else  
          @code = Affiliate.new
        end  
        render :template => 'manage_event/add_affiliate_codes'
     end 
 end
 
 
 
 def delete_affiliate_codes
      @user = User.find(session[:user_id])
     @event = Event.find(params[:id])
    
      eact = 'manage_affiliate'
     @has_affiliate = Event.has_rights(@user, @event, eact)

     if @has_affiliate != 1 
       flash[:notice] = I18n.t 'event_controller.not_access_page'        
       redirect_to(:controller => 'home', :action=>'index' ) and return # else redirect to reffered events
     end
 
   respond_to do |format|
         @code = Affiliate.find(params[:code_id])
         @code.destroy
         
        flash[:notice1] = I18n.t 'manage_event_controller.affiliate_code_deleted_successfully'
        format.html { redirect_to(:action=>'affiliate_codes/'+params[:id].to_s) }
   end
 end
 
 
 ######## Copy Event
 def copy
     
       @user = User.find(session[:user_id])
     @event = Event.find(params[:id])
    
      eact = 'create_event'
     @has_copy = Event.has_rights(@user, @event, eact)

     if @has_copy != 1 
       flash[:notice] = I18n.t 'event_controller.not_access_page'        
       redirect_to(:controller => 'home', :action=>'index' ) and return # else redirect to reffered events
     end

     
     if request.post?
             
         respond_to do |format|
              @event = Event.find(params[:id]).dup
              @old_event = Event.find(params[:id])  
              @site = SiteSetting.find(:first)
              @event[:event_title] = params[:event_title]
              @event[:active] = 0
               if @event[:event_start_date_time] < DateTime.now
                  @event[:event_start_date_time] = (Time.now + @site[:event_start_day].days).strftime("%Y-%m-%d %H:%M:%S")
                  @event[:event_end_date_time] = (Time.now + @site[:event_start_day].days).strftime("%Y-%m-%d %H:%M:%S")
               end  
              @event[:event_url_link]  = ''
             
               if @event.save
                    #### attendees
                    @attendee = Attendee.find(:first, :conditions => ['event_id=?', @old_event[:id]])
                    
                    if @attendee
                      @new_attendee = @attendee.dup
                      @new_attendee[:event_id] = @event[:id]
                      @new_attendee.save
                    
                      @event[:attendee_id] = @new_attendee[:id]
                    end
                    
                    #### event repeats
                    @repeat = EventRepeat.find(:first, :conditions => ['event_id=?', @old_event[:id]])
                    
                    if @repeat
                      @new_repeat = @repeat.dup
                      @new_repeat[:event_id] = @event[:id]
                      @new_repeat.save
                    end
                    
                     #### event theme
                    @theme = EventTheme.find(:first, :conditions => ['event_id=?', @old_event[:id]])
                    
                    if @theme
                      @new_theme = @theme.dup
                      @new_theme[:event_id] = @event[:id]
                      @new_theme.save
                    end
                    
                    
                     
                     #### event tickets
                    @tickets = Ticket.find(:all, :conditions => ['event_id=?', @old_event[:id]])
                    chck_strt_date = (Time.now + @site[:event_start_day].days).strftime("%Y-%m-%d %H:%M")
                    chck_end_date = (Time.now + @site[:event_start_day].days).strftime("%Y-%m-%d %H:%M")
                   
                    if @tickets.count > 0
                       @tickets.each do |ticket|
                            ticket_clone = ticket.dup
                            ticket_clone[:event_id] = @event[:id]
                            
                            
                          # Reset Ticket Start/End date if it is smaller than current date (prakruti)  
				
                            if(ticket_clone[:paid]==1)
                         
                              if ticket_clone[:paid_start_sale] < chck_strt_date
                                 ticket_clone[:paid_start_sale] = chck_strt_date
                              end
                               if ticket_clone[:paid_end_sale] < chck_end_date
                                 ticket_clone[:paid_end_sale] = chck_end_date
                              end
                            
                            
                              elsif (ticket_clone[:free]==1)
         				
                              if ticket_clone[:free_start_sale] <= chck_strt_date
                                 ticket_clone[:free_start_sale] = chck_strt_date
                              end
                               if ticket_clone[:free_end_sale] <= chck_end_date
                                 ticket_clone[:free_end_sale] = chck_end_date
                              end

                           elsif(ticket_clone[:donation]==1)
                            if ticket_clone[:donation_start_sale] < chck_strt_date
                                 ticket_clone[:donation_start_sale] = chck_strt_date
                              end
                               if ticket_clone[:donation_end_sale] < chck_end_date
                                 ticket_clone[:donation_end_sale] = chck_end_date
                              end
                            end  
                         ## end ticket start/end date  
                                          
                            ticket_clone[:used] = 0
                            ticket_clone.save
                        end
                    end
                    
                    
                    # Copy promotional codes
                    @codes = PromotionalCode.find(:all, :conditions => ['event_id=?', @old_event[:id]])
                    if @codes != nil && @codes != ''
                      if @codes.count > 0
                       @codes.each do |code|
                            promo_clone = code.dup
                            promo_clone[:used_cnt] = 0
                            promo_clone[:event_id] = @event[:id]
                            promo_clone.save
                          end
                       end
                    end
                   
                    UserMailer.create_event_email(@event).deliver
                    
                    flash[:notice1] = I18n.t 'manage_event_controller.event_copied_successfully'
                    format.html { redirect_to(:controller => 'events', :action=>'edit/'+@event[:id].to_s ) }
                
                    format.xml  { render :xml => @event, :status => :created, :location => @event }
              else
                    format.html { render :action => "copy", :layout => false }
                    format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
              end
          end
        
        else
           render :layout => false
        end 
        
  end
 
 ######## Cancel event 
  def cancel
     respond_to do |format|
        @event = Event.find(params[:id])
        @event[:cancel] = 1
        @event[:cancel_date_time] = DateTime.now.strftime('%Y-%m-%d %H:%M:%S')
        @event.save
        
        flash[:notice1] = I18n.t 'manage_event_controller.event_cancelled_successfully'
        format.html { redirect_to(:controller => 'events', :action=>'index') }
      end  
  end
  
######## Publish Event
  def publish
  
  
    @user = User.find(session[:user_id])
     @event = Event.find(params[:id])
    
      eact = 'create_event'
     @has_create = Event.has_rights(@user, @event, eact)
     
     
     if @has_create != 1  
       flash[:notice] = I18n.t 'event_controller.not_access_page'        
       redirect_to(:controller => 'home', :action=>'index' ) and return # else redirect to reffered events
     end
     
     respond_to do |format|
        @event = Event.find(params[:id])
        @event[:cancel] = 0
        @event[:active] = 0
        @event.save
        UserMailer.make_event_live_request(@event).deliver
        flash[:notice1] = I18n.t 'manage_event_controller.event_submitted_publishing_wait_admin_approval'
        #flash[:notice1] = "Event Published successfully..!!"
        format.html { redirect_to(:action=>'index/'+@event[:id].to_s) }
      end  
  end
  
######## Delete Event
  def delete
     respond_to do |format|
        @event = Event.find(params[:id])
        
        Attendee.destroy_all("event_id = "+@event[:id].to_s)
        EventRepeat.destroy_all("event_id = "+@event[:id].to_s)
        EventTheme.destroy_all("event_id = "+@event[:id].to_s)
        Ticket.destroy_all("event_id = "+@event[:id].to_s)
        if @event[:organizer_id]>0
          @org = Organizer.find(@event[:organizer_id])
          @org[:event_cnt]= @org[:event_cnt]-1
           @org.save
        end
        @event.destroy
        
        flash[:notice1] = I18n.t 'manage_event_controller.event_deleted_successfully'
        format.html { redirect_to(:controller => 'events', :action=>'index' ) }
       
      end              
  end
  
  ######## Change Event Link
  def event_url_link
   @event = Event.find(params[:id])
   @event[:event_url_link] = params[:val]
   
     if @event.save
        render :json => { :success => true, :msg => (I18n.t 'contact_controller.success')  }
     else
        render :json => { :success => true, :msg => @event.errors.full_messages[0]}
     end  
       
  end
  
  ######## Change Organizer Link
  def org_url_link
   @org = Organizer.find(params[:id])
   @org[:page_url] = params[:val]
   
     if @org.save
        render :json => { :success => true, :msg => (I18n.t 'contact_controller.success')  }
     else
        render :json => { :success => true, :msg => @org.errors.full_messages[0]}
     end  
       
  end
  
  ## Checks whether the event belongs to session user before adding promotional code ##  
  private   
  def validate_event_user(id)
      @event = Event.find(id)
        
        if @event[:user_id] == session[:user_id]
            
        else
               
         redirect_to(:controller => 'home', :action=>'index') 
        end       
  end 
   def cust_ord_form()
      @meta_title = I18n.t 'meta_title.m_customize_order_form'
      @user = User.find(session[:user_id])
      @site = SiteSetting.find(:first)
      @event = Event.find(params[:id])
      @questions = Question.find(:all, :conditions => ['event_id=?', @event[:id]]) 
     
      if request.post?
          
             
                  if params[:ticket]
                      params[:order_form][:tickets] = params[:ticket].join(',')
                  end    
                  
                  if params[:prefix]
                      params[:order_form][:prefix] = params[:prefix].join(',').gsub(',','') 
                  end
                  
                  if params[:first_name]    
                      params[:order_form][:first_name] = params[:first_name].join(',').gsub(',','')
                  end
                  
                  if params[:last_name]      
                      params[:order_form][:last_name] = params[:last_name].join(',').gsub(',','')
                  end
                  
                  if params[:suffix]      
                      params[:order_form][:suffix] = params[:suffix].join(',').gsub(',','')
                  end
                  
                  if params[:email]      
                      params[:order_form][:email] = params[:email].join(',').gsub(',','')
                  end
                  
                  if params[:home_phone]      
                      params[:order_form][:home_phone] = params[:home_phone].join(',').gsub(',','')
                  end
                  
                  if params[:cell_phone]      
                      params[:order_form][:cell_phone] = params[:cell_phone].join(',').gsub(',','') 
                  end
                  
                  if params[:billing_address]     
                      params[:order_form][:billing_address] = params[:billing_address].join(',').gsub(',','') 
                  end
                  
                  if params[:home_address] 
                      params[:order_form][:home_address] = params[:home_address].join(',').gsub(',','') 
                  end
                  
                  if params[:shipping_address] 
                      params[:order_form][:shipping_address] = params[:shipping_address].join(',').gsub(',','') 
                  end
                  
                  if params[:job_title] 
                      params[:order_form][:job_title] = params[:job_title].join(',').gsub(',','') 
                  end
                  
                  if params[:company] 
                      params[:order_form][:company] = params[:company].join(',').gsub(',','') 
                  end
                  
                  if params[:work_address] 
                      params[:order_form][:work_address] = params[:work_address].join(',').gsub(',','') 
                  end
                  
                  if params[:work_phone] 
                      params[:order_form][:work_phone] = params[:work_phone].join(',').gsub(',','') 
                  end
                  
                  if params[:website] 
                      params[:order_form][:website] = params[:website].join(',').gsub(',','') 
                  end
                  
                  if params[:blog] 
                      params[:order_form][:blog] = params[:blog].join(',').gsub(',','') 
                  end
                  
                  if params[:gender] 
                      params[:order_form][:gender] = params[:gender].join(',').gsub(',','') 
                  end
                  
                  if params[:birth_date] 
                      params[:order_form][:birth_date] = params[:birth_date].join(',').gsub(',','') 
                  end
                  
                  if params[:age] 
                      params[:order_form][:age] = params[:age].join(',').gsub(',','') 
                  end
                  
                  if(params[:order_id]==nil || params[:order_id]=='')
                       @order_form = OrderForm.new(params[:order_form])
                       @order_form.save
                  else
                       @order_form = OrderForm.find(params[:order_id])
                       @order_form.update_attributes(params[:order_form])  
                  end 
              
                  if @questions.count > 0
                    for q in @questions
                        @que_id = params[:que_id]
                        if @que_id
                            if(@que_id.include?(q[:id].to_s))
                               if params[:que] && params[:que].count>0
                                  if params[:que][q[:id].to_s]
                                    q[:rules] = params[:que][q[:id].to_s].join(',').gsub(',','')
                                    q.save 
                                  end
                               end   
                            else
                                QuestionOption.destroy_all("que_id = "+q[:id].to_s)
                                Answer.destroy_all("que_id = "+q[:id].to_s)
                                q.destroy
                            end  
                        end
                    end
                  end
                  
                 # flash[:notice1] = I18n.t 'manage_event_controller.info_save_successfully'
                 # redirect_to(:action=>'customize_order_form')
      end       
     
  end
  
end