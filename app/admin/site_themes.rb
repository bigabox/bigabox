ActiveAdmin.register SiteTheme do
  
  #menu :parent => "Setting", :url => "/admin/site_settings/fb_settings" ,:priority => 2
   menu false
  config.clear_sidebar_sections! 
  config.clear_action_items!
  
 controller do
   def index
      redirect_to("/admin/site_themes/1/edit" )
   end
   
   def update
      update! do 
         redirect_to("/admin/site_themes/1/edit" ) and return
      end
   end
 end
  
  #form do |f|
  #    f.inputs "Theme Setting" do
  #    
  #    f.input :color
  #    f.input :color1
  #    f.input :color2
  #    f.input :color3
  #    f.input :colordark
     
  #  end
  #     f.buttons do
  #     f.action(:submit) 
  #   end
  # end
  
    form :html => { :enctype => "multipart/form-data" } do |f|
        render "create" , :layout => 'active_admin'
      end    
  
  
end
