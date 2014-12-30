ActiveAdmin.register Purchase do
   menu false
   
   
     #, :disable_pagination => false

    index :download_links => false, :title => 'Transactions List '+SiteSetting.site_title do      
       @page_title = 'Transactions List'
      
      table_for Purchase.where('ticket_id > 0 and payment=1').order('id desc'), :class => 'index_table index' do
            column "Purchase Id", :id
            column :first_name                     
            column :last_name        
            column :email           
            
            column "Event Title" do |show|  
                @eve = Event.find(show.event_id) 
                @eve[:event_title]  
            end
            
            column :ticket_qty
            column "Amount" do |show| 
              set_currency(show.total)
            end       
            column "Purchased At", :created_at  
      end
                  
    end  
    
   
    
   config.batch_actions = false
   config.clear_action_items!
   config.filters = false
   #config.disable_pagination = false
   
   
   controller do
     def index
        #@page_title = 'Cancel Order '+SiteSetting.site_title
      #  render "cancel" , :layout => 'active_admin'    
        render :text => "Hola" and return
     end
     def cancel
        @page_title = 'Cancel Order '+SiteSetting.site_title
        render "cancel" , :layout => 'active_admin'    
     end
     
     def list
       @page_title = 'Purchased Ticket List '+SiteSetting.site_title
      render "list" , :layout => 'active_admin'  
     end
     
     def monthly
      
      @page_title = 'Monthly Transactions List '+SiteSetting.site_title
      render "monthly" , :layout => 'active_admin'  
     end
     
      def yearly
       @page_title = 'Yearly Transactions List '+SiteSetting.site_title
      render "yearly" , :layout => 'active_admin'  
     end
     
   end
   
end