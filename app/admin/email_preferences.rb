ActiveAdmin.register EmailPreference do
   menu false
  index :title => 'Email Preference'+SiteSetting.site_title do 
      column "User Id",:user_id  
      column :user                  
      column :attendee_update do |check|
      if check.attendee_update==1
          render :inline => "<label for="">YES</label>"
        else
          render :inline => "<label for="">NO</label>"
        end
      end       
      column :attendee_picks  do |check|
      if check.attendee_picks==1
          render :inline => "<label for="">YES</label>"
        else
          render :inline => "<label for="">NO</label>"
        end
      end  
      #column :attendee_unsubscribe        
      column :attendee_buy_ticket do |check|
      if check.attendee_buy_ticket==1
          render :inline => "<label for="">YES</label>"
        else
          render :inline => "<label for="">NO</label>"
        end
      end
      column :org_update do |check|
      if check.org_update==1
          render :inline => "<label for="">YES</label>"
        else
          render :inline => "<label for="">NO</label>"
        end
      end
      
      column :org_picks do |check|
      if check.org_picks==1
          render :inline => "<label for="">YES</label>"
        else
          render :inline => "<label for="">NO</label>"
        end
      end
      #column :org_unsubscribe
      column :org_next_event do |check|
      if check.org_next_event==1
          render :inline => "<label for="">YES</label>"
        else
          render :inline => "<label for="">NO</label>"
        end
      end
      column :org_order_confirm  do |check|
      if check.org_order_confirm==1
          render :inline => "<label for="">YES</label>"
        else
          render :inline => "<label for="">NO</label>"
        end
      end
      
      default_actions
  end
  
  filter :user ,:as => :select,:include_blank => true, :collection => User.all.map{|u| ["#{u.email}", u.id]}
  
  controller do
  	def new
  	   @email_preference=EmailPreference.new
  	end
  end
  
  form :html => { :enctype => "multipart/form-data" } do |f|
      f.inputs do
         f.input :user ,:lable =>'User Name' ,:as => :select,:include_blank => true, :collection => User.all.map{|u| ["#{u.email}", u.id]}
         f.input :attendee_update , :as => :select,:include_blank => false,:collection =>[['YES', 1],['NO', 0]]
         f.input :attendee_picks , :as => :select,:include_blank => false,:collection =>[['YES', 1],['NO', 0]]
         #f.input :attendee_unsubscribe , :as => :select,:include_blank => false,:collection =>[['YES', 1],['NO', 0]]
         f.input :attendee_buy_ticket , :as => :select,:include_blank => false,:collection =>[['YES', 1],['NO', 0]]
         f.input :org_update , :as => :select,:include_blank => false,:collection =>[['YES', 1],['NO', 0]]
         
         f.input :org_picks , :as => :select,:include_blank => false,:collection =>[['YES', 1],['NO', 0]]
         #f.input :org_unsubscribe , :as => :select,:include_blank => false,:collection =>[['YES', 1],['NO', 0]]
         f.input :org_next_event , :as => :select,:include_blank => false,:collection =>[['YES', 1],['NO', 0]]
         f.input :org_order_confirm , :as => :select,:include_blank => false,:collection =>[['YES', 1],['NO', 0]]
      end
      f.buttons do
           f.action(:submit) 
       end
    end
end