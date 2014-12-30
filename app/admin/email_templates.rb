ActiveAdmin.register EmailTemplate do
  #menu :parent => "Setting",:priority => 9
  menu false
  
  index :title => 'Email Templates'+SiteSetting.site_title do       
     h4 :style => 'text-align: right;'  do
       span do
        render :inline => 'You can change "From" & "Reply" address for all Email Templates <a href="/admin/email_templates/change_address/email">Form Here</a>.'
       end
     end 
        
      column :from_name                    
      column :task        
      column :subject    
      column :from_address        
      column :reply_address         
      
      column do |show|
        link_to image_tag('event.png'), {:action => show.id.to_s}
      end
      
      column do |show|
        link_to 'Edit', {:action => show.id.to_s+'/edit'}
      end 
  end  
  
   show :title => 'Email Template'+SiteSetting.site_title do |show|
      render "view" , :layout => 'active_admin'
   end
   
     #config.batch_actions = false
     #config.clear_action_items!
     
     filter :from_name
     filter :task
     filter :subject 
     filter :from_address 
     filter :reply_address 
     
     
     controller do
     
     
     def edit
       @email_template = EmailTemplate.find(params[:id])
       #render :text => @email_template.errors and return
     end
     
     def new
	  @email_template= EmailTemplate.new
	  
     end
       
       def change_address
          if request.post?
              @from = params[:from_address]
              @reply = params[:reply_address]
              @name = params[:from_name]
              
              EmailTemplate.update_all(["from_address = ?, reply_address = ?, from_name = ?  ", params[:from_address], params[:reply_address], params[:from_name]])
              redirect_to("/admin/email_templates" )
          else
              render 'change_address', :layout => 'active_admin'
          end  
       end
       
     end
     
	form :html => { :enctype => "multipart/form-data" } do |f|  
        render "create" , :layout => 'active_admin'
    end
     
end