ActiveAdmin.register NewsletterTemplate do
   menu false
  index :title => 'Newsletter Template'+SiteSetting.site_title do 
      column :id
      column :from_name
      column :from_address
      column :reply_address  
      column :subject                     
      column :attach_file    
      #column :allow_unsubscribe_link  
      
      column do |show|
        link_to image_tag('event.png'), {:action => show.id.to_s}
      end
      
      #default_actions      
  end
  
  show :title => 'Email Template'+SiteSetting.site_title do |show|
      render "view" , :layout => 'active_admin'
   end
  
   filter :subject
   
  controller  do
  
    def new
      @newsletter_template=NewsletterTemplate.new
    end
  
    def edit
      @newsletter_template=NewsletterTemplate.find(params[:id])
    end
    
    def create
      create! do
         @file = NewsletterTemplate.last
         if params[:attach_file]
           num1 = 'News_'+SecureRandom.hex(5)
           name = num1+'_'+params[:attach_file]['datafile'].original_filename
           directory = "public/data/newsletter"
           ext = params[:attach_file]['datafile'].original_filename.split(".")
           if ext[1]=='pdf' || ext[1]=='docx'
              path = File.join(directory, name)
              File.open(path, "wb") { |f| f.write(params[:attach_file]['datafile'].read) }
              
              @file[:attach_file] = name
              @file.save 
            else
                redirect_to("/admin/newsletter_templates/new",  :flash => { :error => 'Upload PDF,DOCX only.' } ) and return
             end
           end
      end
    end
    
  def update
    update! do 
      if params[:attach_file]
        num1 = 'News_'+params[:id]
        name = num1+'_'+params[:attach_file]['datafile'].original_filename
        directory = "public/data/newsletter"
        ext = params[:attach_file]['datafile'].original_filename.split(".")
         if ext[1]=='pdf' || ext[1]=='docx'
          path = File.join(directory, name)
           File.open(path, "wb") { |f| f.write(params[:attach_file]['datafile'].read) }
           
           NewsletterTemplate.update_all(['attach_file=?', name],['id=?',params[:id]])
           @newsletter_template = NewsletterTemplate.find(params[:id])
        end
      end
    end
  end
  
  end
  
    form :html => { :enctype => "multipart/form-data" } do |f|
        render "create" , :layout => 'active_admin'
    end
      
end