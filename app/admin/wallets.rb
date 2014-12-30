ActiveAdmin.register Wallet do
  config.sort_order = "id_desc"
  menu false
  #menu :parent => "Wallet" ,:priority => 2, :label => "Confirm Withdrawals"
  actions :all, :except => [:new]
  
   config.batch_actions = false
   config.clear_action_items!
   config.filters = false
   
   index :title => 'Confirmed Withdrawals'+SiteSetting.site_title do 
     render "index" , :layout => 'active_admin'
   end
   
   
end


