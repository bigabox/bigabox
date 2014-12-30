ActiveAdmin.register City do
   #menu :parent => "Setting" ,:priority => 10, :label => "Cities [Footer Dropdown]"
   menu false
   index :title => 'Cities'+SiteSetting.site_title do       
      column :city_name                    
     
      column "Current Status" do |show|
        if show.active==0
          links = 'Inactive'
        else  
          links = 'Active'
        end  
      end
      
      column "Change Status" do |show|
        if show.active==0
          links = link_to image_tag('tick1.png', :title => 'Activate') + ' Activate ', {:action => 'active/'+show.id.to_s}
        else  
          links = link_to image_tag('eb_close.png', :title => 'Deactivate') + ' Deactivate ', {:action => 'inactive/'+show.id.to_s}
        end  
      end
      
      default_actions 
  end  
  
  
   
   controller do
        def active
          City.update_all(["active = ? ", 1], ["id = ?", params[:id]])
          redirect_to "/admin/cities/", :notice => 'City Activated Successfully.'
        end
        
        def inactive
          City.update_all(["active = ? ", 0], ["id = ?", params[:id]])
          redirect_to "/admin/cities/", :notice => 'City Deactivated Successfully.'
        end  
        
        def show 
            redirect_to("/admin/cities" )
        end
   end
     
     config.batch_actions = false
     
     
     filter :city_name
   
     
     
      form :html => { :enctype => "multipart/form-data" } do |f|
       
        f.inputs  do
          f.input :city_name
         
       end
       
       f.buttons do
           f.action(:submit) 
       end
     end   
end
