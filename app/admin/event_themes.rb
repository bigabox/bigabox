ActiveAdmin.register EventTheme do
  menu false
  index :download_links => false do
  
   column :event_title                     
   
  end 
   config.batch_actions = false
end
