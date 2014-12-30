ActiveAdmin.register Gallery do
    menu false
   index do       
      column 'Image' do |show|
        #image_tag('/data/orig/gallery/'+show.name, :width => '150', :height => '150')
        render :inline => '<img src="'+APP_CONFIG['development']['upload_url']+'data/orig/gallery/'+show.name+'" alt="" width="150" height="150" />' 
      end               
     
      column "Current Status" do |show|
        if show.active==0
          links = 'Inactive'
        else  
          links = 'Active'
        end  
      end
      
      column "Change Status" do |show|
        if show.active==0
          links = link_to image_tag('tick1.png', :title => 'Activate') + ' Activate ', {:action => 'active/'+show.id.to_s}
        else  
          links = link_to image_tag('eb_close.png', :title => 'Deactivate') + ' Deactivate ', {:action => 'inactive/'+show.id.to_s}
        end  
      end
      
      default_actions 
  end  
  
   
   
   controller do
        
   
        def show 
            redirect_to("/admin/galleries" )
        end
         
        def active
          Gallery.update_all(["active = ? ", 1], ["id = ?", params[:id]])
          redirect_to "/admin/galleries/", :notice => 'Gallery Image Activated Successfully.'
        end
        
        def inactive
          Gallery.update_all(["active = ? ", 0], ["id = ?", params[:id]])
          redirect_to "/admin/galleries/", :notice => 'Gallery Image Deactivated Successfully.'
        end  
        
        def update
            update! do 
                
                if params[:upload]
                    num1 = 'gallery_'+SecureRandom.hex(5)
                    name = num1+'_'+params[:upload]['datafile'].original_filename
                    directory = "public/data/orig/gallery"
                    
                      ext = params[:upload]['datafile'].original_filename.split(".")
                   # render :text => ext and return
                   if ext[1]=='jpg' || ext[1]=='jpeg' || ext[1]=='png' || ext[1]=='gif'  || ext[1]=='JPG' || ext[1]=='JPEG' || ext[1]=='PNG' || ext[1]=='GIF'  
                      path = File.join(directory, name)
                      File.open(path, "wb") { |f| f.write(params[:upload]['datafile'].read) }
                     
                      Gallery.update_all(['name=?', name],['id=?',params[:id]])
                      redirect_to("/admin/galleries", :notice => 'Gallery Image Updated Succesfully.' ) and return
                   else
                        redirect_to("/admin/galleries/new",  :flash => { :error => 'Upload JPEG, PNG or GIF Image only.' } ) and return
                   end 
                end
              
            end
         end
         
         def create
             create! do  
               if params[:upload]
                    num1 = 'gallery_'+SecureRandom.hex(5)
                    name = num1+'_'+params[:upload]['datafile'].original_filename
                    directory = "public/data/orig/gallery"
                    ext = params[:upload]['datafile'].original_filename.split(".")
                   # render :text => ext and return
                   if ext[1]=='jpg' || ext[1]=='jpeg' || ext[1]=='png' || ext[1]=='gif'  || ext[1]=='JPG' || ext[1]=='JPEG' || ext[1]=='PNG' || ext[1]=='GIF'  
                      path = File.join(directory, name)
                      File.open(path, "wb") { |f| f.write(params[:upload]['datafile'].read) }
                     
                      @gallery = Gallery.new
                      @gallery[:name] = name
                      @gallery.save
                      redirect_to("/admin/galleries", :notice => 'Gallery Image Added Succesfully.' ) and return
                   else
                        redirect_to("/admin/galleries/new",  :flash => { :error => 'Upload JPEG, PNG or GIF Image only.' } ) and return
                   end 
                end
              
            end   
         end
         
   end
     
     config.batch_actions = false
     config.filters = false
     
      form :html => { :enctype => "multipart/form-data" } do |f|
        
        f.inputs  do
           if f.object.new_record?       
                f.input :name, :as => :file, :input_html => { :name => 'upload[datafile]' }
           else
                f.input :name, :as => :file, :input_html => { :name => 'upload[datafile]' }, :hint => f.template.image_tag(APP_CONFIG['development']['upload_url']+'/data/orig/gallery/'+gallery.name, :width => '150', :height => '150')    
           end
           
       end
       
       f.buttons do
           f.action(:submit) 
       end
     end    

end
