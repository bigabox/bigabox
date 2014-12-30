ActiveAdmin.register UserAddress do
  menu false
   
   
   show :title => "User Addresses"+SiteSetting.site_title do |show|
      render "view" , :layout => 'active_admin'
   end
   
  controller do
     
      
   def index 
      redirect_to("/admin/users" ) and return
   end
   
      def list
        @page_title = 'User Address'+SiteSetting.site_title
        @addr = UserAddress.find(:first, :conditions => ['user_id=?', params[:id]])
        if @addr
           redirect_to(:action => "/"+@addr[:id].to_s) 
        else
            redirect_to(:action => 'new', :user => params[:id])
        end
        
      end
      
    def new
     @user_address=UserAddress.new
   end
  end
  
  
   config.clear_action_items!   
      
   form :html => { :enctype => "multipart/form-data" } do |f|
      render 'new', :layout => 'active_admin'     
   end   
  
end