ActiveAdmin.register SiteSetting do
    #menu :parent => "Setting",:priority => 1
  menu false
  
  config.clear_sidebar_sections! 
  config.clear_action_items!
 
  
 controller do
   def index
      redirect_to("/admin/site_settings/1/edit" )
   end
   
   def edit
       	@site_setting = SiteSetting.find(1)
   end
   
   def update
      update! do 
          
          if params[:upload]
              num1 = 'logo_'+SecureRandom.hex(5)
              name = num1+'_'+params[:upload]['datafile'].original_filename
              directory = "public/data/orig/other"
              path = File.join(directory, name)
              File.open(path, "wb") { |f| f.write(params[:upload]['datafile'].read) }
              SiteSetting.update_all(['site_logo=?', name],['id=?',1])
          end
          
          if params[:upload_hover]
              num1 = 'logo_hover_'+SecureRandom.hex(5)
              name = num1+'_'+params[:upload_hover]['datafile'].original_filename
              directory = "public/data/orig/other"
              path = File.join(directory, name)
              File.open(path, "wb") { |f| f.write(params[:upload_hover]['datafile'].read) }
              SiteSetting.update_all(['site_logo_hover=?', name],['id=?',1])
          end     
         
      end
   end
   
   def show
     redirect_to("/admin/site_settings/1/edit" )
   end
   
   
   def fb_settings
     @fb = FacebookSetting.find(:first)
     if request.post?
        @fb.update_attributes(params[:facebook_setting])
        redirect_to("/admin/site_settings/fb_settings" )
     else
        render "fb_settings" , :layout => 'active_admin'
     end   
   end
   
   
 end
  
  form :html => { :enctype => "multipart/form-data" } do |f|
     
      f.inputs "Basic Site Setting" do
   
        f.input :site_name
    		f.input :site_language, :as => :select,:include_blank => false, :collection => Language.all.map{|u| ["#{u.language_name}", u.id]}
    		
    		f.input :verify_account, :label => 'Verify Account on Sign up', :as => :select,:include_blank => false, :collection =>[['Disable', 0],['Enable', 1]]
    		f.input :forgot_time_limit, :label => 'Forgot Password Time Limit (Hours)', :min => 1
    		f.input :site_mode, :label => 'Site Mode', :as => :select,:include_blank => false, :collection =>[['Testing Mode', 0],['Live Mode', 1]]
		    f.input :feature_limit, :label => 'Feature Event Limit', :min => 1
		    f.input :upcoming_limit, :label => 'Upcoming Event Limit', :min => 1
      end
	  
	   f.inputs "Currency" do
   
       	f.input :currency_symbol, :label => 'Currency', :as => :select,:include_blank => false, :collection => CurrencyCode.all.map{|u| ["#{u.currency_code}, #{u.currency_symbol}", u.currency_symbol]}
    		f.input :currency_symbol_side, :label => 'Where to display Currency Symbol? ',:as => :select,:include_blank => false, :collection =>[["$100","left"],["$ 100","left_space"],["100$","right"],["100 $","right_space"],["USD100 ","left_code"],["USD 100","left_space_code"],["100USD","right_code"],["100 USD","right_space_code"]] 
    		f.input :decimal_points, :label => 'Decimal Points After Amount', :as => :select,:include_blank => false, :collection =>[[0, 0],[1, 1],[2, 2]] 
      end
    f.inputs "Date Time" do
 
     	f.input :date_format
  		#f.input :time_format
  		f.input :date_time_format
	
    end
  
    f.inputs "Event Setting" do
        f.input :paid_ticket_fee,  :label => 'Paid Ticket Fee (%)'
        f.input :event_start_day, :label => 'Event Start Day (No. of Day)'
      # f.input :event_end_day, :label => 'Event End Day (No. of Day)'
        f.input :min_purchase_allowed, :label => 'Minimum Purchase Ticket'
        f.input :max_purchase_allowed, :label => 'Maximum Purchase Ticket'
        f.input :max_ticket_qnty, :label => 'Maximum Ticket Quantity'
        f.input :max_ticket_price, :label => 'Maximum Ticket Price'
        f.input :test_payments, :label => 'Payment Testing Mode', :as => :select,:include_blank => false, :collection =>[['Disable', 0],['Enable', 1]]
        f.input :payment_gateway, :label => 'Payment Gateway', :as => :select,:include_blank => false, :collection =>[['PayPal', 'paypal'],['Authorize.Net', 'auth']] 
    end
	   
	  f.inputs "Site Logo" do
 
		    f.input :site_logo, :as => :file, :input_html => { :name => 'upload[datafile]' }, :hint => f.template.image_tag(APP_CONFIG['development']['upload_url']+'/data/orig/other/'+site_setting.site_logo, :width => '252', :height => '79') 
		    f.input :site_logo_hover, :as => :file, :input_html => { :name => 'upload_hover[datafile]' }, :hint => f.template.image_tag(APP_CONFIG['development']['upload_url']+'/data/orig/other/'+site_setting.site_logo_hover, :width => '252', :height => '79')
		
    end
     
    f.inputs "Help & Other Setting" do
        f.input :home_tage_line,  :label => 'Home Page Tag Line', :input_html => { :style => 'height:15px; resize:none;' }
        f.input :admin_phone, :label => 'Help Line Number'
        f.input :event_help_line, :label => 'Event Help Line Number'
        f.input :tech_support, :label => 'Technical Support Number'
        f.input :outside_us_help, :label => 'Outside US Help Number' 
    end
    
    f.inputs "Social Link Setting" do
        f.input :facebook_link,  :label => 'Footer Facebook Link'
        f.input :twitter_link, :label => 'Footer Twitter Link'
        f.input :gplus_link, :label => 'Footer Google Plus Link'
        f.input :linked_link, :label => 'Footer LinkedIn Link'
        f.input :yahoo_link, :label => 'Footer Yahoo Link'
    end
    
    f.inputs "Meta Setting" do
        f.input :meta_keyword
        f.input :meta_description
    end
    
    
    
       f.buttons do
	     f.action(:submit) 
	   end
    end
	
	
end