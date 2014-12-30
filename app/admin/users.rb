ActiveAdmin.register User do
  #menu :priority => 3
  menu false
   
      
  index :title => 'Users'+SiteSetting.site_title do       
      column :first_name                    
      column :last_name        
      column :email   
      
       column 'User IP Address', :user_ip
                   
      column "Events" do |show|
        links = link_to image_tag('event.png', :title => 'Events'), {:controller => 'events', :action => 'list/'+show.id.to_s}
      end 
      column "Purchases" do |show|  
        links = link_to image_tag('ticketimg.png', :title => 'Tickets'), {:controller => 'purchases', :action => 'list/'+show.id.to_s}
      end
      
      #column "Multi Users" do |show|
      #  links = link_to image_tag('accountimg.png', :title => 'MultiUser Account', :height => '21'), {:controller => 'users', :action => 'list/'+show.id.to_s}
     # end
      
      column "Addresses" do |show|
        links = link_to image_tag('address.png', :title => 'Address', :height => '21'), {:controller => 'user_addresses', :action => 'list/'+show.id.to_s}
      end
      
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
     
       column do |show|
          links = '<a class="member_link view_link" href="/admin/users/'+show.id.to_s+'">View</a>' 
          links += ' '
          links += '<a class="member_link edit_link" href="/admin/users/'+show.id.to_s+'/edit">Edit</a>'
          
          @events = Event.find(:all, :conditions =>  ["user_id = ? AND active = ? AND cancel = ?", show.id, 1, 0] )
          if @events.count <= 0
            links += ' '
            links += '<a class="member_link delete_link" data-confirm="Are you sure you want to delete this?" href="/admin/users/destroy_user/'+show.id.to_s+'">Delete</a>'
          end
          render :inline => links
        end  
     
  end  
  
   show :title => 'User'+SiteSetting.site_title do |show|
     
      render "view" , :layout => 'active_admin'
   end
   
    controller  do
      
      
      
       def new
	 @user =  User.new
	  #redirect_to("/admin/users/create/1" )
       end
       
       def edit
       @user = User.find(params[:id])
       #render :text => @email_template.errors and return
     end

        def update
            update! do 
               redirect_to("/admin/users/", :notice => "User Information updated successfully." ) and return
            end
        end
      
        def list
          @page_title = 'MultiUsers List'+SiteSetting.site_title
          render "list" , :layout => 'active_admin'
          #render :text => params   
        end
       
         
        def destroy_user
            user_id = params[:id].to_i
            @user = User.find(user_id)
            if session[:user_id]==user_id
              session[:user_id] = nil
              session[:user_email] = nil
            end
            if @user
              @user.destroy
            end
            
            @emailpref = EmailPreference.find(:first , :conditions => ['user_id=?', user_id])
            if @emailpref
              @emailpref.destroy
            end
            
            @permission = Permission.find(:first , :conditions => ['user_id=?', user_id])
            if @permission
              @permission.destroy
            end
            redirect_to "/admin/users/", :notice => 'User Account Deleted Successfully.'
        end
                
        def delete_user
            user_id = params[:id].to_i
            @user = User.find(user_id)
            if session[:user_id]==user_id
              session[:user_id] = nil
              session[:user_email] = nil
            end
            if @user
              ref_id = @user[:ref_id]
              @user.destroy
            else 
              ref_id = 0
            end
            
            
            @permission = Permission.find(:first , :conditions => ['user_id=?', user_id])
            if @permission
              @permission.destroy
            end
            if ref_id == 0
               redirect_to "/admin/users/", :notice => 'User Account Deleted Successfully.'
            else
                 redirect_to(:action => 'list/'+ref_id.to_s)
            end 
           
        end
        
        def active
          User.update_all(["active = ? ", 1], ["id = ?", params[:id]])
          redirect_to "/admin/users/", :notice => 'User Account Activated Successfully.'
        end
        
        def inactive
          User.update_all(["active = ? ", 0], ["id = ?", params[:id]])
           if session[:user_id]==params[:id]
              session[:user_id] = nil
              session[:user_email] = nil
            end
          redirect_to "/admin/users/", :notice => 'User Account Deactivated Successfully.'
        end
        
       def view_chart
          render "view_chart" , :layout => 'active_admin'
       end
       
    end

   
   
    filter :first_name
	  filter :last_name
	  filter :email
	  
	   form :html => { :enctype => "multipart/form-data" } do |f|
     		f.inputs "Basic Information" do
  			  f.input :prefix
  			  f.input :first_name
  			  f.input :last_name
  			  f.input :suffix
  			  
          
			 end
			 
			 f.inputs "Other Information" do
          if f.object.new_record?
              f.input :email
              f.input :password
          else
            f.input :email,:input_html => { :type => 'text',:readonly =>'readonly' }
          end 
          
          f.input :home_phone
          f.input :cell_phone
          
       end
       
       
			 f.buttons do
           f.action(:submit) 
       end
		 end	 
end