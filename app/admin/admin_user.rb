ActiveAdmin.register AdminUser do     
  #menu :priority => 2
  menu false
  
  
  
  index :title => 'Admin Users'+SiteSetting.site_title do                          
    column :email                     
    column 'Current Login', :current_sign_in_at        
    column 'Last Login', :last_sign_in_at           
    column 'Login count', :sign_in_count             
    #current_admin_user[:id]
    @count = AdminUser.count
   if @count == 1
      column do |show|
        links = link_to 'View', {:action => show.id.to_s}
        links += ' '
        links += link_to 'Edit', {:action => show.id.to_s+'/edit'}
        links
      end  
   else
     default_actions
   end  
  
                      
  end                                 

  controller do
    def password
      render :text => 'test'
    end
    
     def new
           @admin_user = AdminUser.new
      end
    
  end
  filter :email                       

  
  
  form do |f|                         
    f.inputs "Admin Details" do       
      f.input :email                  
      f.input :password               
      f.input :password_confirmation  
    end                               
    f.actions                         
  end                                 
end                                   