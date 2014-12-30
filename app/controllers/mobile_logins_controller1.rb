class MobileLoginsController < ApplicationController
  
  def index
       @meta_title = 'Login'
      @user = User.new()
      @type = 'login'
     
  end
   
  def post_login
    if request.post?
          user = User.authenticate(params[:user_email], params[:user_password])
          if user
            if user.active == 1
                if MobileLogin.where(:user_id => user.id).count == 0
                  @mobile = MobileLogin.new
                  @mobile[:user_id] = user.id
                  @mobile.save
                end
                render :json => { :success => true, :status => 1, :msg => user.id }
            else
                render :json => { :success => true, :status => 0, :msg => "Your account is inactive. Contact administrator to activate it..!!"  }
            end        
          else
                render :json => { :success => true, :status => 0, :msg => "Invalid user/password combination" }
          end
    end
  end
  
  
  def myevent
      if request.post?
        id = params[:id] 
        checkin_status=params[:checkin_status]
        
            @all_events = Event.find_live_events(id)
            @count_of_ticket = []
            @sold = []
            @count_attendee = []
            @count_checkin_attendee = []
            
            i=0
            for e in @all_events
                
                @sold[i] = Ticket.find_event_sold_count(e[:id])
                
                @count_of_ticket[i] = e[:event_capacity]
               # @sold[i] = @free1.to_i+@paid1.to_i+@don1.to_i
                @count_attendee[i] = Purchase.find(:all, :conditions => ["event_id = ? and ticket_id > 0", e[:id]]).count 
                @count_checkin_attendee[i] = Purchase.find(:all, :conditions => ["event_id = ? and ticket_id > 0 and checkin_status=1", e[:id]]).count 
               i+=1 
            end
            
              
            render :json => { :success => true, :status => 1, :all_events => @all_events, :count_of_ticket => @count_of_ticket, :sold => @sold, :count_attendee => @count_attendee, :count_checkin_attendee =>@count_checkin_attendee }     
      end   
   end
   
   def attendee
     if request.post?
       id = params[:id]
       event_id=params[:event_id]
              
          @all_attendee= Purchase.find(:all, :conditions => ['event_id = ? AND ticket_id > 0 ',event_id])
          ticket_type = []
          i=0
          for att in @all_attendee
            if Ticket.exists?(att[:ticket_id])
                @tic = Ticket.find(att[:ticket_id])
                if @tic[:free]==1
                  ticket_type[i] = 'Free'
                elsif @tic[:paid]
                  ticket_type[i] = 'Paid'
                else
                    ticket_type[i] = 'Donation'  
                end
             else
                  ticket_type[i] = 'N/A'  
             end   
            i+=1
          end
                          
          render :json => { :success => true, :status => 1, :msg => @all_attendee, :ticket_type => ticket_type}            
     end
  end 
   
  def update_attendee_single
    if request.post?
      @attendee_id=params[:attendee_id]
      @checkin_status=params[:checkin_status]
                     
      @att = Purchase.find(:first, :conditions => ['id=?', @attendee_id])
     if @att
      @att[:checkin_status]=@checkin_status        
     
       if @att.save
         ret = 1
      else
         ret = 0
      end   
     else
        ret = 0
     end   
      render :json =>{:success =>true, :status => 1, :msg => ret }
    end
  end
  
 
  def update_attendee_pull
    if request.post?
            
            @attendee_id=params[:attendee_id]
            @checkin_status=params[:checkin_status]
            
             
         
            
            ret=[]
            i=0
            for att in @attendee_id
                  @att = Purchase.find(:first, :conditions => ['id=?', att.to_i])
                  if @att  
                    @att[:checkin_status]=@checkin_status[i]
                    if @att.save
                    
                      ret[i] = 1
                    else
                     
                       ret[i] = 0
                    end 
                 else
                   ret[i] = 0
                 end      
               i+=1
            end
         render :json =>{:success =>true, :status => 1, :msg => ret }
    end
  end
  
  def myevent_details
    if request.post?
      event_id=params[:event_id]
      
      @event = Event.find(event_id)
      
      @sold = Ticket.find_event_sold_count(@event[:id])
                
      @count_of_ticket = @event[:event_capacity]
      
      #@count_attendee = Purchase.find(:all, :conditions => ["event_id = ? and ticket_id > 0", @event[:id]]).count
      #@count_attendee = Ticket.find_event_sold_count(@event[:id])
      
      #@count_checkin_attendee = Purchase.find(:all, :conditions => ["event_id = ? and ticket_id > 0 and checkin_status=1", @event[:id]]).count
      @count_checkin_attendee = Purchase.sum(:ticket_qty, :conditions => "event_id = #{@event[:id]} and ticket_id > 0 and checkin_status=1 and (payment=1 or attendee_id > 0) ") 
      
      render :json => { :success => true, :status => 1, :event => @event, :count_of_ticket => @count_of_ticket, :sold => @sold, :count_attendee => @sold, :count_checkin_attendee =>@count_checkin_attendee }
    end
  end
  
  def ticket_check
    if request.post?
      barcode_random =params[:ticket_number]
      event_id =params[:event_id]
      
      @attendee = Purchase.find(:all, :conditions => ["barcode_random = ? AND event_id = ? AND ticket_id > 0 ", barcode_random, event_id])
      
       ret=[]
       i=0
     if @attendee.count > 0  
      for a in @attendee
          if a[:checkin_status]==1
            ret[i] = 'This attendee already checked In.'
          else
            a[:checkin_status]=1
            a.save
            ret[i] = a[:id]
          end
          i+=1
      end
    else
      ret[0]='Barcode does not exists.'
    end    
      render :json => { :success => true, :status => 1, :attendee_id => ret }
    end
  end
  
  def mobile_logout
    if request.post?
      id = params[:id]
      
      logout = MobileLogin.find(:first,:conditions =>['user_id = ?',id])
      if logout
        logout.destroy
        @logout = "You have logged out successfully..!!"
      else
        @logout = "You have logged out already..!!"
      end   
      
      render :json => { :success => true, :status => 1, :logout => @logout}
      
    
    end
  end

   
end
