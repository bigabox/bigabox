ActiveAdmin.register WalletSetting do
   #menu :parent => "Setting", :url =>  "/admin/wallet_settings/1/edit"  ,:priority => 5
   menu false
   #ActiveAdmin.register_page "Dashboard" do

 # menu :priority => 5, :label => proc{ I18n.t("active_admin.dashboard") }

   
    config.clear_sidebar_sections! 
    config.clear_action_items!
  
  controller do
  
     def index
      redirect_to("/admin/wallet_settings/1/edit" )
     end
     
     def edit
      	@wallet = WalletSetting.find(1)
     end
     
       
     def update
        update! do |format|
            redirect_to("/admin/wallet_settings/1/edit") and return
        end
     end
  end
  
   form  do |f|
      
      f.inputs "Wallet Setting" do
	    #f.input :wallet_enable,:as => :select,:include_blank => false, :collection =>[["Active", 1],["Inactive", 0]] 
		  f.input :paypal_withdraw_fees, :label => 'Paypal Withdraw Fees (%)'
		  f.input :bank_withdraw_fees, :label => 'Bank Withdraw Fees (%)'
		  f.input :cheque_withdraw_fees, :label => 'Cheque Withdraw Fees (%)'


		
	  end
       f.buttons do
	     f.action(:submit) 
	   end
    end
	
end