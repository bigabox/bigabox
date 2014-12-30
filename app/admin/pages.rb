ActiveAdmin.register Page do
  menu false
    actions :all, :except => [:destroy]  
   index :title => 'Pages'+SiteSetting.site_title do       
      column :pages_title                    
      #column 'Header', :header_bar        
      column 'Footer', :footer_bar                
      
      column "Current Status" do |show|
        if show.active==0
          links = 'Inactive'
        else  
          links = 'Active'
        end  
      end
      
      column "Change Status" do |show|
        if show.active==0
          links = link_to ' Activate ', {:action => 'active/'+show.id.to_s}, :class => 'green'
        else  
          links = link_to ' Deactivate ', {:action => 'inactive/'+show.id.to_s}, :class => 'red'
        end  
      end
      
      default_actions 
  end  
  
   show :title => "Page Detail"+SiteSetting.site_title do |show|
      render "view" , :layout => 'active_admin'
   end
   
   
   controller do
        def active
          Page.update_all(["active = ? ", 1], ["id = ?", params[:id]])
          redirect_to "/admin/pages/", :notice => 'Page Activated Successfully.'
        end
        
        def inactive
          Page.update_all(["active = ? ", 0], ["id = ?", params[:id]])
          redirect_to "/admin/pages/", :notice => 'Page Deactivated Successfully.'
        end  
        
        def new
           @page = Page.new
        end
       
       def edit
       	@page = Page.find(params[:id])
      end
     
   end
     
     config.batch_actions = false
     
     
     filter :pages_title
     filter :description
     
     
      form :html => { :enctype => "multipart/form-data" } do |f|
        render "create" , :layout => 'active_admin'
      end    
     
end