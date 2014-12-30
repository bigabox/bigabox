module ApplicationHelper
  
   
   def check_img(img,type,folder)
       if img!='' && img != nil 
         
         full_path = "/public/data/#{folder}/#{type}/#{img}"
         
         if FileTest.exist?("#{Rails.root}/"+full_path)
             render :text =>   "data/#{folder}/#{type}/#{img}"
         else
            if folder=='thumb'
              folder1 = "orig"
            else
              folder1 = "thumb"
            end
            full_path = "/public/data/#{folder1}/#{type}/#{img}"
            
             if FileTest.exist?("#{Rails.root}/"+full_path)
               render :text =>   "data/#{folder1}/#{type}/#{img}"
             else
                 render :text =>  "0"
             end
         end      
       else  
             render :text =>  "0"
       end
    end
    
   
   def event_title(id)
      
       @event_title = Event.find(id)
     if @event_title !=nil
       return @event_title[:event_title]
     end
      #event_title = Event.select("event_title").where(id)
      #return event_title[0][:event_title]
   end  
   
   
   def ticket_name(id)
    if id > 0
     @tic = Ticket.find(id)
     if @tic[:free]==1
        return @tic[:free_ticket_name] 
     elsif @tic[:paid]==1
        return @tic[:paid_ticket_name]
     else
        return @tic[:donation_ticket_name]   
     end
    end 
   end  
   ############ set amount with currency ############
  
  def set_currency(amt)  
  
    @site = SiteSetting.find(:first)
    
    if amt=='' || amt==nil
       amt=0
    end  
     
      if(@site[:currency_symbol_side] == 'left')
        
         amount = number_to_currency(amt, :unit => @site[:currency_symbol], :separator => ".", :delimiter => ",", :precision => @site[:decimal_points], :negative_format => "-%u%n", :format => "%u%n")
      
      
      elsif(@site[:currency_symbol_side] == 'left_space')
        
         amount = number_to_currency(amt, :unit => @site[:currency_symbol], :separator => ".", :delimiter => ",", :precision => @site[:decimal_points], :negative_format => "-%u %n", :format => "%u %n")
      
      
      elsif(@site[:currency_symbol_side] == 'right')
        
         amount = number_to_currency(amt, :unit => @site[:currency_symbol], :separator => ".", :delimiter => ",", :precision => @site[:decimal_points], :negative_format => "-%n%u", :format => "%n%u")
      
      elsif(@site[:currency_symbol_side] == 'right_space')
        
         amount = number_to_currency(amt, :unit => @site[:currency_symbol], :separator => ".", :delimiter => ",", :precision => @site[:decimal_points], :negative_format => "-%n %u", :format => "%n %u")
     
      elsif(@site[:currency_symbol_side] == 'left_code')
        
         amount = number_to_currency(amt, :unit => @site[:currency_code], :separator => ".", :delimiter => ",", :precision => @site[:decimal_points], :negative_format => "-%u%n", :format => "%u%n")
      
      elsif(@site[:currency_symbol_side] == 'left_space_code')
        
         amount = number_to_currency(amt, :unit => @site[:currency_code], :separator => ".", :delimiter => ",", :precision => @site[:decimal_points], :negative_format => "-%u %n", :format => "%u %n")
      
      elsif(@site[:currency_symbol_side] == 'right_code')
        
         amount = number_to_currency(amt, :unit => @site[:currency_code], :separator => ".", :delimiter => ",", :precision => @site[:decimal_points], :negative_format => "-%n%u", :format => "%n%u")
      
      else
        
         amount = number_to_currency(amt, :unit => @site[:currency_code], :separator => ".", :delimiter => ",", :precision => @site[:decimal_points], :negative_format => "-%n %u", :format => "%n %u")
      end
    
    amount
    
  end
  
  ############## set currency end ###########
    
    
  def paypal_amt(amt)
    if amt=='' || amt==nil
       amt=0
    end  
      amount = number_to_currency(amt, :unit => "", :separator => ".", :delimiter => "", :precision => 2)
      amount
  end  
  
  
  def cancel_available(date)
    @site = SiteSetting.find(:first)
    chk_date = (date + @site[:cancel_time_limit].hours).strftime('%Y-%m-%d %H:%M:%S')
    now_date = Time.now.strftime('%Y-%m-%d %H:%M:%S')
    
    if now_date > chk_date
      0
    else
      1
    end
  end  
  
  def has_action_rights(action)
      @has = 0
	     @user = User.find(session[:user_id])
	     act = action
	     # check if user is reffered
	      if @user[:ref_id]!=nil && @user[:ref_id]!='' && @user[:ref_id] > 0
	          #Check persmission
	          @permission = Permission.find(:first, :conditions => ['user_id=? AND admin_id=?', @user[:id], @user[:ref_id]]) 
	          @per_act = @permission[:action].split(',')
	           if ((@permission[:action]=='all' || @per_act.include?(act)) )
	                @has = 0 # if user has right to create event/my events procced
	           else
	                @has = 1
	                #flash[:notice] = I18n.t 'event_controller.not_access_page'        
	                #redirect_to(:controller => 'home', :action=>'index' ) # else redirect to reffered events
	           end 
	       # @reffer = 1
	     else
	        @has = 0
	     end
      
      return @has
   end
  
   
end
