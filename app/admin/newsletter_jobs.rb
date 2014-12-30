ActiveAdmin.register NewsletterJob do
  menu false
   index :title => 'Newsletter Job'+SiteSetting.site_title do
      column :id  
      #column "Newsletter Id" ,:newsletter_id  
      column :check_send do |check|
        if check.check_send==1
          render :inline => '<a href="" style="text-decoration: none;" readonly="readonly" class="green">Sent</a>'
        else
          render :inline => '<a href="" style="text-decoration: none;" readonly="readonly" class="red">Pending</a>'
        end
      end                       
      #column :send_total    
      
      column :newstype do |show|
          if show.newstype=="updateA"
            render :inline => "<label for="">Attending announcements and update</label>"
          else
            render :inline => "<label for="">Organizing announcements and update</label>"
          end
      end
      
      column :job_start_date  
      
      default_actions      
   end
   
   controller do
   	def new
           @newsletter_job = NewsletterJob.new
           #redirect_to("/admin/newsletterjobs/create/1" )
   	end
   	
      def edit
       	@newsletter_job = NewsletterJob.find(params[:id])
       #render :text => @email_template.errors and return
     end
   	
   end
   
   filter :job_start_date
   form :html => { :enctype => "multipart/form-data" } do |f|
        render "create" , :layout => 'active_admin'
    end
end