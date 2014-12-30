ActiveAdmin.register AuthorizeSetting do
 menu false
 #  menu :parent => "Setting" ,:priority => 12, :url => "/admin/authorize_settings/1/edit"
   
 config.clear_sidebar_sections! 
 config.clear_action_items!
  
 controller do
   def index
      redirect_to("/admin/authorize_settings/1/edit" )
   end
    
   def update
      update! do 
        flash[:notice] = 'Authorize Setting was successfully updated.'
         redirect_to("/admin/authorize_settings/1/edit" ) and return
      end
   end
 end
  
  form do |f|
      f.inputs "Authorize Setting" do
       # f.input :active,:as => :select,:include_blank => false, :collection =>[["Active", 1],["Inactive", 0]] 
        
        f.input :x_site_status,:as => :select,:include_blank => false, :collection =>[["Sand Box", 'sandbox'],["Live", 'live']] , :label => 'Site Status'
        f.input :x_desc, :label => 'x_description'
        f.input :x_method, :label => 'x_method'
        f.input :x_type, :label => 'x_type'
        f.input :x_trans_key, :label => 'Merchant unique Transaction Key'
        f.input :x_login, :label => 'Merchant unique API Login ID'
      end
       f.buttons do
         f.action(:submit)
       end
    end
end
