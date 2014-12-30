class WalletController < ApplicationController
  def index
      @meta_title = I18n.t 'meta_title.manage_wallet'
      @user = User.find(session[:user_id])
      @site = SiteSetting.find(:first)
      @event_wallet = Wallet.event_wallet_amount(@user[:id])
      @ref_wallet = Wallet.ref_wallet_amount(@user[:id])
      @aff_wallet = Wallet.aff_wallet_amount(@user[:id])
      #render :text => @ref_wallet.count
  end
  
   def withdraw
    if params[:id]
      
        send_withdraw(params[:id])
        flash[:notice1] = I18n.t 'wallet_controller.withdraw_request_send'
        redirect_to :action => 'index'
        
    elsif params[:all_id].count > 0
        @all = params[:all_id]
        @all.each do |id|
          send_withdraw(id)
        end
        
        flash[:notice1] =  I18n.t 'wallet_controller.withdraw_request_send'
        redirect_to :action => 'index'
        
    else
      redirect_to :action => 'index'
    end
  end
  
  def withdraw_event
    
    #render :text => params.inspect and return
    @user = User.find(session[:user_id])
    @event = Event.find(params[:event_id])
    # Wallet Withdraw
    @with = WalletWithdraw.new
    #@with[:wallet_id] = @wallet[:id]
    @with[:withdraw_ip] = request.remote_ip
    @with[:user_id] = @user[:id]
    @with[:event_id] = @event[:id]
    @with[:withdraw_amount] = params[:withdraw_amt]
    @with[:withdraw_method] = params[:withdraw_mode]
    @with[:due] = params[:withdraw_amt]
    
    if @with.save
      @with_txn = WalletTransactionDetail.new
      @withid = WalletWithdraw.find(:last)
      
      #Bank Details
      @with_txn[:wallet_withdraw_id] = @withid[:id]
      @with_txn[:bank_name] = params[:bank_name]
      @with_txn[:bank_branch] = params[:bank_branch]
      @with_txn[:bank_ifsc_code] = params[:bank_ifsc_code]
      @with_txn[:bank_address] = params[:bank_address]
      @with_txn[:bank_city] = params[:bank_city]
      @with_txn[:bank_state] = params[:bank_state]
      @with_txn[:bank_country] = params[:bank_country]
      @with_txn[:bank_zipcode] = params[:bank_zipcode]
      @with_txn[:bank_account_holder_name] = params[:bank_account_holder_name]
      @with_txn[:bank_account_number] = params[:bank_account_number]
      
      #Cheque Details
      @with_txn[:cheque_name] = params[:cheque_name]
      @with_txn[:cheque_branch] = params[:cheque_branch]
      @with_txn[:cheque_ifsc_code] = params[:cheque_ifsc_code]
      @with_txn[:cheque_account_number] = params[:cheque_account_number]
      @with_txn[:org_address] = params[:org_address]
      @with_txn[:org_city] = params[:org_city]
      @with_txn[:org_state] = params[:org_state]
      @with_txn[:org_country] = params[:org_country]
      @with_txn[:org_zipcode] = params[:org_zipcode]
      
      #Gateway Details
      @with_txn[:gateway_name] = params[:gateway_name]
      @with_txn[:gateway_account] = params[:gateway_account]      
      
      @with_txn.save
    end

    flash[:notice1] = I18n.t 'wallet_controller.withdraw_request_send'
    redirect_to :action => 'index'
    
   
  end
  
  def withdraw_account
    
    @user = User.find(session[:user_id])
    @event = Event.find(params[:id])
          
    # Withdraw Transaction Details
    
=begin  
  if params[:id]
      
        send_withdraw_event(params[:id])
        flash[:notice1] = I18n.t 'wallet_controller.withdraw_request_send'
       # redirect_to :action => 'index'
        
    elsif params[:all_id].count > 0
        @all = params[:all_id]
        @all.each do |id|
          send_withdraw_event(id)
        end
        
        flash[:notice1] =  I18n.t 'wallet_controller.withdraw_request_send'
      #  redirect_to :action => 'index'
        
    else
      #redirect_to :action => 'index'
    end
    #@event = Event.find(params[:id])
=end  
  
  end
  
  
  def withdraw123
    if params[:id]
       @meta_title = I18n.t 'meta_title.withdraw_wallet'
       @user = User.find(session[:user_id])
       @site = SiteSetting.find(:first)
       @wallet = Wallet.find(params[:id])
      
       if request.post?
          @amount = @wallet[:due].to_f + params[:amount].to_f
          Wallet.update_all(["due = ? ", @amount], ["id = ?", @wallet[:id]])
          
          @with = WalletWithdraw.new
          @with[:wallet_id] = @wallet[:id]
          @with[:withdraw_ip] = request.remote_ip
          @with[:user_id] = @user[:id]
          @with[:withdraw_amount] = params[:amount]
          
          @with.save
           
          UserMailer.withdraw_request(@user, @with).deliver
          flash[:notice1] =  I18n.t 'wallet_controller.withdraw_request_send'
          redirect_to :action => 'index'
       end
    else
      redirect_to :action => 'index'
    end
  end
  
  private
  def send_withdraw(id)
      @user = User.find(session[:user_id])
      @wallet = Wallet.find(id)
      @amount = @wallet[:credit].to_f
      Wallet.update_all(["due = ?, sent_with=1 ", @amount], ["id = ?", @wallet[:id]])
      
      @with = WalletWithdraw.new
      @with[:wallet_id] = @wallet[:id]
      @with[:withdraw_ip] = request.remote_ip
      @with[:user_id] = @user[:id]
      @with[:withdraw_amount] = @amount
      
      @with.save
      UserMailer.withdraw_request(@user, @with).deliver
  end
  
end