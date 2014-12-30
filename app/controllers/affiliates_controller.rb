class AffiliatesController < ApplicationController
  before_filter :authorize, :only => [:events]
    
  def index
     @meta_title = I18n.t 'meta_title.affiliates'
     @aff = Affiliate.where(:public => 1).paginate(:page => params[:page], :per_page => 20).order('id DESC')
  end
  
  def join
    @aff = Affiliate.find(:first, :conditions => ['name=?', params[:id]])
    if @aff[:user_id]!=session[:user_id]
        Affiliate.update_all(["visits=? ", @aff[:visits]+1], ["id = ?", @aff[:id]])
    end    
    if(session[:user_id] == nil) 
        session[:affiliate_id]=@aff[:id]
    else
        if @aff[:user_id]!=session[:user_id]
            @join = UserJoin.find(:first, :conditions => ['user_id=? and affiliate_id=?', session[:user_id], @aff[:id]])
            if @join
                flash[:notice] = I18n.t 'notice.already_join'
                redirect_to :controller => 'manage_account', :action => 'affiliates'
            else
                @join = UserJoin.new
                @join[:user_id] = session[:user_id]
                @join[:affiliate_id] = @aff[:id]
                @join.save
                Affiliate.update_all(["affiliates = ?", @aff[:affiliates]+1], ["id = ?", @aff[:id]])
                flash[:notice] = I18n.t 'notice.success_join'
                redirect_to :controller => 'manage_account', :action => 'affiliates'
            end
       end   
    end    
  end
  
  
  #############  use affiliate link starts ***********
  def events
    if params[:id]
        url_id = Base64.decode64(params[:id])
        ids = url_id.split('_')
        #a[:id].to_s+'_'+a[:user_id].to_s+'_'+@aff[:id].to_s+'_'+@event[:id].to_s
        user_join_id = ids[0]
        user_id = ids[1]
        affiliate_id = ids[2]
        event_id = ids[3]
        @aff = Affiliate.find(affiliate_id)
        
        if user_id==session[:user_id] || @aff[:user_id]==session[:user_id]
             redirect_to :controller => 'home', :action => 'index'
             #render :text => session[:user_id] 
        else 
            
            if Event.exists?(event_id) 
              UserJoin.update_all(["site_visits = site_visits+1 "], ["id = ?",user_join_id])
              session[:aff_user_join_id] = user_join_id
              session[:aff_visiter_id] = session[:user_id]
              session[:aff_event_id] = event_id
              session[:aff_affiliate_id] = affiliate_id
              
                @event = Event.find(event_id)   
                if @event[:event_url_link]=='' || @event[:event_url_link]==nil 
                  page_url = APP_CONFIG['development']['site_url']+'events/view/'+@event[:id].to_s 
                else
                  page_url = APP_CONFIG['development']['site_url']+'event/'+@event[:event_url_link]
                end
                
                redirect_to(page_url)
           else
              redirect_to :controller => 'home', :action => 'index'  
           end 
            
        end
    else
        redirect_to :controller => 'home', :action => 'index'  
    end
  end
  ############ use affiliate link ends
  
end
