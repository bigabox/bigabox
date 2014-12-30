ActiveAdmin.register Tip do
   #menu :parent => "Setting" ,:priority => 11
   menu false
   actions :all, :except => [:destroy]
   config.batch_actions = false
     
   filter :title
   filter :desc
     
   index :title => 'Tips'+SiteSetting.site_title do       
      column :tip_type 
      column :title 
     
      default_actions 
   end
   
   show :title => 'Tip'+SiteSetting.site_title do |show|
     render "view" , :layout => 'active_admin'
   end
   
   controller do
   
     def new
        @tip=Tip.new 
     end
     
   end
   
    form do |f|
      f.inputs "Tip" do
          f.input :tip_type,:as => :select,:include_blank => false, :collection =>[["Expert Tip", "Expert Tip"],["Ticket Tip", "Ticket Tip"],["Promote Tip", "Promote Tip"]] 
          f.input :title
          f.input :desc, :as => :html_editor
      end
      
      f.buttons do
       f.action(:submit) 
      end
    end  
  
end
