ActiveAdmin.register FacebookSetting do
   #menu :parent => "Setting", :url => "/admin/site_settings/fb_settings" ,:priority => 2
   menu false
  config.clear_sidebar_sections! 
  config.clear_action_items!
  
 controller do
   def index
      redirect_to("/admin/facebook_settings/1/edit" )
   end
   
   def update
      update! do 
         redirect_to("/admin/facebook_settings/1/edit" ) and return
      end
   end
 end
  
  form do |f|
      f.inputs "Facebook Setting" do
	  	f.input :facebook_login_enable,:as => :select,:include_blank => false, :collection =>[["Active", 1],["Inactive", 0]] 
  		f.input :facebook_application_id
  		f.input :facebook_access_token
  		f.input :facebook_api_key
	  end
       f.buttons do
	     f.action(:submit) 
	   end
    end
end
