ActiveAdmin.register TwitterSetting do
	 #menu :parent => "Setting", :url => "/admin/twitter_settings/1/edit"  ,:priority => 3
	 menu false
	  config.clear_sidebar_sections! 
    config.clear_action_items!
	  
	  
	  
	  controller do
        def index
           redirect_to("/admin/twitter_settings/1/edit" )
        end
   
   
        def update
            update! do |format|
                redirect_to("/admin/twitter_settings/1/edit") and return
            end
        end
    end
    
	  form do |f|
      f.inputs "Twitter Setting" do
	  	f.input :twitter_enable,:as => :select,:include_blank => false, :collection =>[["Active", 1],["Inactive", 0]] 
		f.input :consumer_key
		f.input :consumer_secret
		f.input :tw_oauth_token
		f.input :tw_oauth_token_secret
	  end
      f.buttons do
	     f.action(:submit) 
	   end
    end
	
	 
end
