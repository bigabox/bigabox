class MyTicketsController < ApplicationController
   
    before_filter :authorize
   
    def index
        @meta_title = I18n.t 'meta_title.my_tickets'
       # @tickets = Purchase.where('ticket_id = 0 and payment=1 and user_id='+session[:user_id].to_s).order('id DESC')
        @site = SiteSetting.find(:first)
        @user = User.find(session[:user_id])
        @purchase = Purchase.where('payment=1 and user_id='+session[:user_id].to_s).order('id DESC')
        @this_week_events = Event.find(:all, :conditions => ['event_start_date_time > ? AND event_start_date_time < ? AND active = ? AND cancel = ? AND user_id = ?', Time.now, Time.now + 7.days, 1, 0, session[:user_id]])
    end
    
   def view
        @meta_title = I18n.t 'meta_title.my_tickets'
        @my_ticket = Purchase.find(params[:id])
        @event = Event.find(@my_ticket[:event_id])
        @country = Country.find_all_country()
        @questions = Question.find(:all, :conditions => ['event_id=? AND que_type!="waiver" AND (rules="11" or rules="1")', @event[:id]])
        @waivers = Question.find(:all, :conditions => ['event_id=? AND que_type="waiver" AND (rules="11" or rules="1")', @event[:id]])
        @order = OrderForm.find(:first, :conditions => ['event_id=?', @event[:id]])
        @all_tickets = Purchase.find(:all, :conditions => ['transaction_key=? ', @my_ticket[:transaction_key].to_s])
        @all_tickets = Purchase.find(:all, :conditions => ['transaction_key=? ', params[:id].to_s])
        @site = SiteSetting.find(:first)
        @order = OrderForm.find(:first, :conditions => ['event_id=?', @event[:id]])
        @user = User.find(session[:user_id])
        @this_week_events = Event.find(:all, :conditions => ['event_start_date_time > ? AND event_start_date_time < ? AND active = ? AND cancel = ? AND user_id = ?', Time.now, Time.now + 7.days, 1, 0, session[:user_id]])
        
    end
    
    
    

   # Function Name :  download_invoice
   # Parameter : purchaseid , eventid , ticketid
   # return : none
   # use : Click on Download Invoice button to download_invoice.pdf.erb and convert PDF file use for wkhtmltopdf
 
  def download_invoice
    
   @my_ticket = Purchase.find(params[:id])
   @event = Event.find(@my_ticket[:event_id])
   respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @my_ticket }
      format.pdf do
        render :pdf => "#{@event.event_title}",
               :wkhtmltopdf => 'vendor/bundle/ruby/1.8/bin/wkhtmltopdf',   ##Path for wkhtmltopdf
               :template => '/my_tickets/download_invoice.pdf.erb',
               :disposition => "inline",
               :print_media_type => true  
      end
      
      format.json { render :json => @my_ticket }
    end
    
 end
 
     
  
    
  def download_pdf
     @pur = Purchase.find(params[:id])
     if (@pur[:transaction_key] && @pur[:transaction_key]>0)
      # @pur = Purchase.find(@pur[:transaction_key])
     end
     
     send_file 'public/data/docs/'+@pur[:random_no]+'.pdf', :type =>'application/pdf', :disposition => 'attachment'  
  end
    
end