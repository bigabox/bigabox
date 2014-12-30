ActiveAdmin.register Theme do
 menu false
  index do       
      
    column :name                     
    column :event_title        
    column :background           
    column :header_text             
    default_actions                   
  end  
   config.batch_actions = false
   
    filter :name
	 filter :event_title
	  filter :background 
end
