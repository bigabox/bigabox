ActiveAdmin.register WalletWithdraw do
  #menu :parent => "Wallet" ,:priority => 1, :label => "Pending Withdrawals"
  menu false
 actions :all, :except => [:new]
  
   config.batch_actions = false
   config.clear_action_items!
   config.filters = false
     
   index :title => 'Pending Withdrawals'+SiteSetting.site_title do
     render "index" , :layout => 'active_admin'
   end
   
   controller do
     def confirm
       if params[:id] 
          withdraw_con(params[:id])
          UserMailer.confirm_withdraw_request(params[:id]).deliver
    
       elsif params[:all_id].count > 0
          @all = params[:all_id]
          @all.each do |id|
            withdraw_con(id)
            UserMailer.confirm_withdraw_request(id).deliver
          end
       end     
       
        redirect_to "/admin/wallet_withdraws/", :notice => 'Withdrawal Request Confirmed Successfully.'
     end
     
     def detail
       if params[:id]
         @with = WalletWithdraw.find(params[:id])
         @with_detail = WalletTransactionDetail.find(:first, :conditions => ["wallet_withdraw_id = ?", @with[:id]]) 
       end
       render "detail" , :layout => 'active_admin'
     end
     
    
     
     private
     def withdraw_con(id)
        @with = WalletWithdraw.find(id)
        #@wallet = Wallet.find(@with[:wallet_id])
        
        if  @wallet && @wallet[:ref_id]>0
          @ref = ReferralCode.find(@wallet[:ref_id])
          @ref[:due] = @ref[:due].to_f - @with[:withdraw_amount].to_f
          @ref[:paid] = @ref[:paid].to_f + @with[:withdraw_amount].to_f
          @ref.save
        end
          
        if  @wallet && @wallet[:aff_id]>0  
          @aff = Affiliate.find(@wallet[:ref_id])
          @aff[:due] = @aff[:due].to_f - @with[:withdraw_amount].to_f
          @aff[:paid] = @aff[:paid].to_f + @with[:withdraw_amount].to_f
          @aff.save
        end
        
        #@wallet[:due] = @wallet[:due].to_f - @with[:withdraw_amount].to_f
        #@wallet[:paid] = @wallet[:paid].to_f + @with[:withdraw_amount].to_f
       # @wallet.save
         
        @with[:withdraw_status] = 1
        @with[:paid] = @with[:paid].to_f + @with[:due].to_f
        @with[:due] = 0.00
        @with.save  
     end
     
   end
   
   
   
end