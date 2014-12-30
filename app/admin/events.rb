ActiveAdmin.register Event do
   #menu :priority => 4
   menu false
   
  
  # actions :all, :except => [:show]
   
   index :title => 'Events'+SiteSetting.site_title do    
     div :id => 'eventerror', :style => 'color: #f00; text-align: center;' do
     end
       
     h4 :style => 'text-align: right;'  do
       span do
        render :inline => '<a href="javascript://"  onclick="return check_with_submit(0);"><img src="/assets/tick1.png" alt="Tick1"> Make Feature </a> '
       end
       span :style => 'margin-left: 20px;' do
        render :inline => '<a href="javascript://"  onclick="return check_with_submit(1);"><img src="/assets/eb_close.png" alt="Tick1"> Cancel Feature </a> '
       end 
     end 
     
       #table_for Event.where(:user_id => params[:id], :cancel => 0) do
      script do
        render :inline => "function check_with_submit(type){
            
            $('#eventerror').text('');
            var chks = document.getElementsByName('all_id[]');
            var fl = true;
            var arr = [];
            for (var i = 0; i < chks.length; i++)
                {
                    if (chks[i].checked==true)
                    {
                           fl = false;
                           arr[i] = chks[i].value;
                    }
                 }
                 
                 if(fl==true){
                  $('#eventerror').text('Select atleast one record..!!');
                  return false;
                 }else{
                    var ids = arr.toString();
                    
                    if(type==0){
                      window.location.href = 'events/make_feature/'+ids;
                    }else{
                      window.location.href = 'events/cancel_feature/'+ids;
                    }
                    
                 }
          }"
      end
       
      
        
            column do |show|
              if  show.event_end_date_time > Time.now.strftime('%Y-%m-%d %H:%I:%S') && show.active==1 && show.cancel==0
                render :inline => '<input type="checkbox" name="all_id[]" value="'+show[:id].to_s+'" />'
              end  
            end
            column :event_title                     
            column "Venue Name" , :vanue_name        
            column :street_address           
            column "Event Start(Date/Time)", :event_start_date_time   
            column "Event End(Date/Time)", :event_end_date_time          
            
            column "Feature" do |show|  
                if show.feature==1 
                  image_tag('tick1.png')
                else
                  image_tag('eb_close.png')
                end    
            end
             
            
            column "Current Status" do |show|
              if show.cancel==1
                links = 'Cancelled'
              
              elsif show.active==0
                links = 'Draft'
              elsif  show.event_end_date_time > Time.now.strftime('%Y-%m-%d %H:%I:%S')
                links = 'Live'
              else  
                links = 'Completed'
              end  
            end
           
            column "Tickets" do |show|  
              links = link_to image_tag('ticketimg.png', :title => 'Tickets'), {:controller => 'tickets', :action => 'index/'+show.id.to_s}
            end
             
           column "Manage" do |show|
               links = link_to image_tag('event.png', :title => 'Manage'), { :action => 'manage', :id => show.id}
           end
           
           
           column do |show|
    
            links += '<a class="member_link edit_link" href="/admin/events/'+show.id.to_s+'/edit">Edit</a>'
            
       
            if show.active==0
              links += ' d'
              links += '<a class="member_link delete_link" data-confirm="Are you sure you want to delete this?" href="/admin/events/delete_event/'+show.id.to_s+'">Delete</a>'
            end
            render :inline => links
        end  
        
       #   default_actions
           
            
       
  end  
  
  
    controller  do
    
     def edit
       @event = Event.find(params[:id])
       #render :text => @email_template.errors and return
     end

      def list
        @page_title = 'Event List'+SiteSetting.site_title
        
        render "list_event" , :layout => 'active_admin'
        #render :text => params   
      end
      
      def delete_event 
          @event = Event.find(params[:id])
          user_id = @event[:user_id]
          
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
          redirect_to(:action => 'index', :notice => 'Event was successfully destroyed.')
      end
      
      
       def destroy 
          @event = Event.find(params[:id])
          user_id = @event[:user_id]
          
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
          redirect_to "/admin/events/", :notice => 'Event was successfully destroyed.'
      end
      
      
        def active
          Event.update_all(["active = 1, cancel = 0 "], ["id = ?", params[:id]])
          @event = Event.find(params[:id])
          UserMailer.confirm_live_event(@event).deliver
          redirect_to "/admin/events/manage/"+params[:id].to_s, :notice => 'Event Activated Successfully.'
        end
        
        def inactive
          Event.update_all(["cancel = 1 , cancel_date_time = ?", Time.now.strftime('%Y-%m-%d %H:%M:%S')], ["id = ?", params[:id]])
          @event = Event.find(params[:id])
          UserMailer.cancel_event_notification(@event).deliver
          redirect_to "/admin/events/manage/"+params[:id].to_s, :notice => 'Event Deactivated Successfully.'
        end 
        
        def manage
          @site = SiteSetting.find(:first)
          @event = Event.find(params[:id])
          @event_attendee = EventAttendee.find(:all, :conditions => ['event_id=?', @event[:id]]).paginate(:page => params[:attendee_page], :per_page => 5)
          @orders = Purchase.find_orders_by_event_admin(@event[:id],params[:order_page])
                   
          @page_title = @event[:event_title]+SiteSetting.site_title
          render "manage" , :layout => 'active_admin'
        end
        
        def make_feature
          @ids = params[:id].split(',')
          @site = SiteSetting.find(:first)
          
          for i in @ids
            @cnt = Event.find_featured_events
            
            if @cnt.count >= @site[:feature_limit]
            else
                Event.update_all(["feature = 1 "], ["id = ?", i])
            end
          end
          
          if @cnt.count>=@site[:feature_limit]
              redirect_to "/admin/events", :notice => @site[:feature_limit].to_s+' Event(s) made featured Successfully. If you want to make another now then cancel some events first from featured list.'
          else
              redirect_to "/admin/events", :notice => 'Event(s) made featured Successfully.'
          end
          
        end
        
        def cancel_feature
          @ids = params[:id].split(',')
          for i in @ids
            Event.update_all(["feature = 0 "], ["id = ?", i])
          end
          
          redirect_to "/admin/events", :notice => 'Event(s) removed from featured Successfully.'
        end
      
    end

  
     config.batch_actions = false
     config.clear_action_items!
     
     filter :event_title
     filter :vanue_name
     filter :street_address 
     
     form :html => { :enctype => "multipart/form-data" } do |f|
        render "create" , :layout => 'active_admin'
      end  
     
     
  end