ActiveAdmin.register Ticket do
   menu false
   
   
     #, :disable_pagination => false

    index :title => 'Tickets'+SiteSetting.site_title do      
      
      render "index" , :layout => 'active_admin'            
    end  
    
    controller do
       def show
          @tic = Ticket.find(params[:id])
         redirect_to("/admin/tickets/index/"+ @tic[:event_id].to_s )
       end
       
       def new
          # @tic[:event_id] = params[:id]
          # render :text => params[:id] and return
           @ticket = Ticket.new
       end
       
       def destroy
         @tic = Ticket.find(params[:id])
         event_id = @tic[:event_id]
         if @tic[:free]==1
           x=@tic[:free_qty]
         elsif @tic[:paid]==1
           x=@tic[:paid_qty]  
         elsif @tic[:donation]==1
           x=@tic[:donation_qty]
         end
        
         @tic.destroy
         
        
         @event = Event.find(@tic[:event_id])
         @event[:event_capacity] = @event[:event_capacity] - x
         @event.save
         
         redirect_to("/admin/tickets/index/"+ event_id.to_s )
       end
       
    end
    
   config.batch_actions = false
   config.clear_action_items!
   config.filters = false
	 #config.disable_pagination = false
	   
  form :html => { :enctype => "multipart/form-data" } do |f|
       @site = SiteSetting.find(:first)

       if f.object.new_record?
          @tic= Ticket.new
          
          if params[:type]=='free'    
              @tic[:free]=1
          end
          
          if params[:type]=='paid'    
              @tic[:paid]=1
          end
          
          if params[:type]=='donation'    
              @tic[:donation]=1
          end
          @tic[:event_id] = params[:id]
       else
       
          @tic= Ticket.find(params[:id])
       end
       
       if request.post?
         @tic[:event_id] = params[:ticket][:event_id]
       end
          
        f.buttons do
         link_to 'Back to Events', :controller => 'events'
        end
         
      f.inputs do
       
       if @tic[:free]==1
           
              f.input :free_ticket_name
              f.input :free_description
              f.input :free_start_sale, :as => :datetime
              f.input :free_end_sale, :as => :datetime
              f.input :free_qty
              f.input :free, :as => :hidden, :input_html => { :value => 1 }
              f.input :paid, :as => :hidden, :input_html => { :value => 0 }
              f.input :donation, :as => :hidden, :input_html => { :value => 0 }
       end
       
       if @tic[:paid]==1
          
              f.input :paid_ticket_name
              f.input :paid_description
              f.input :paid_start_sale, :as => :datetime
              f.input :paid_end_sale, :as => :datetime
              f.input :paid_qty
              f.input :paid_price
              f.input :paid, :as => :hidden, :input_html => { :value => 1 }
              f.input :free, :as => :hidden, :input_html => { :value => 0 }
              f.input :donation, :as => :hidden, :input_html => { :value => 0 }
       end
       
       
       if @tic[:donation]==1
           
              f.input :donation_ticket_name
              f.input :donation_description
              f.input :donation_start_sale, :as => :datetime
              f.input :donation_end_sale, :as => :datetime
              f.input :donation_qty
              f.input :donation, :as => :hidden, :input_html => { :value => 1 }
              f.input :paid, :as => :hidden, :input_html => { :value => 0 }
              f.input :free, :as => :hidden, :input_html => { :value => 0 }
       end
              f.input :event_id, :as => :hidden, :input_html => { :value => @tic[:event_id] }
              f.input :type, :as => :hidden, :input_html => { :value => params[:type], :name => 'type' }
     end   
      
       
       f.buttons do
           f.action(:submit) 
         
       end
     end    
end