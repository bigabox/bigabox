ActiveAdmin.register CancelOrder do
  menu false
  #menu :parent => "Wallet" ,:priority => 2, :label => "Confirm Withdrawals"
  actions :all, :except => [:new]
  
   config.batch_actions = false
   config.clear_action_items!
   config.filters = false
   
   
   index :title => 'Pending Cancelled Orders '+SiteSetting.site_title do
     render "index" , :layout => 'active_admin'
   end
   
    controller do
        def confirm_cancel
            if params[:id] 
                CancelOrder.update_all(["with_con = 1"], ["id = ?", params[:id]])
                UserMailer.confirm_cancel_withdraw_request(params[:id]).deliver
             elsif params[:all_id].count > 0
                @all = params[:all_id]
                @all.each do |id|
                  CancelOrder.update_all(["with_con = 1"], ["id = ?", id])
                  UserMailer.confirm_cancel_withdraw_request(id).deliver
                end
             end     
            redirect_to "/admin/cancel_orders/", :notice => 'Cancel Order Payment Confirmed Successfully.'
         end
         
         def confirms
           
            @page_title = 'Confirmed Cancelled Orders'+SiteSetting.site_title
            render "confirms" , :layout => 'active_admin'    
         end
         
    end
end
