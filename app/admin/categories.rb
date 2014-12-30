ActiveAdmin.register Category do
  
    menu false
    actions :all, :except => [ :destroy]
    config.clear_sidebar_sections! 
   
   index :title => 'Categories'+SiteSetting.site_title do
       script do
         render :inline => ' $(document).ready(function() { $("#index_footer").hide(); }); '
       end
       table_for Category.where(:category_parent_id => 0 ), :class => 'index_table index' do 
            column :category_name                     
            column :category_description
 
            column "Category Status" do |show|
                if show.category_status == 0
                    links = link_to image_tag('tick1.png', :title => 'Activate') + ' Activate ', {:action => 'active/'+show.id.to_s}
                else  
                    links = link_to image_tag('eb_close.png', :title => 'Deactivate') + ' Deactivate ', {:action => 'inactive/'+show.id.to_s}
                end  
            end
            
            column 'Category Image' do |show|
                img_full_path = check_img(show.category_image,'category','orig') 
                if img_full_path!='0' && img_full_path!='' 
                  render :inline => '<img src="'+APP_CONFIG['development']['upload_url']+img_full_path+'" alt="" width="150" height="150" />'
                else
                  render :inline => '<img src="'+APP_CONFIG['development']['app_url']+'demo_image.png" alt="" width="150" height="150" />'
                end     
             end
             
            column 'Child Category' do |show|
              render :inline => '<a href="/admin/categories/child_categories/'+show.id.to_s+'"/>Child Category'
            end
            
            
              default_actions
            
         end
     end
     
      # Displays detail information of the respective category on click of the "view" link..
     show :title => 'Category' + SiteSetting.site_title do |show|     
      render "view" , :layout => 'active_admin'
   end
        
  controller  do
  
   def new
     @category=Category.new
   end
   
   def edit
     @category=Category.find(params[:id])
   end
   
=begin
    def show
      @category = Category.find(params[:id])
      @page_title = @category[:category_name]+SiteSetting.site_title
      if @category[:category_parent_id]==0
          #redirect_to("/admin/categories", :notice => 'Category Updated Succesfully.' ) and return
      else
          redirect_to("/admin/categories/child_categories/"+@category[:category_parent_id].to_s, :notice => 'Child Category Updated Succesfully.' ) and return
       end    
    end
=end    
    
    def active
        Category.update_all(["category_status = ? ", 1], ["id = ?", params[:id]])
        redirect_to "/admin/categories/", :notice => 'Category Image Activated Successfully.'
    end
        
    def inactive
        Category.update_all(["category_status = ? ", 0], ["id = ?", params[:id]])
        redirect_to "/admin/categories/", :notice => 'Category Image Deactivated Successfully.'
    end 
        
    def create
        create! do  
          @category = Category.last
          if params[:upload]
             num1 = 'category_'+SecureRandom.hex(5)
             name = num1+'_'+params[:upload]['datafile'].original_filename
             directory = "public/data/orig/category"
             ext = params[:upload]['datafile'].original_filename.split(".")
            
             if ext[1]=='jpg' || ext[1]=='jpeg' || ext[1]=='png' || ext[1]=='gif'  || ext[1]=='JPG' || ext[1]=='JPEG' || ext[1]=='PNG' || ext[1]=='GIF'  
                 path = File.join(directory, name)
                 File.open(path, "wb") { |f| f.write(params[:upload]['datafile'].read) }
                         
               
                 @category[:category_image] = name
                 @category.save
                 
                
                if @category[:category_parent_id]!=0 && @category[:category_parent_id]!=nil && @category[:category_parent_id]!=''
                    redirect_to("/admin/categories/child_categories/"+@category[:category_parent_id].to_s, :notice => 'Child Category Updated Succesfully.' ) and return
                else
                  redirect_to("/admin/categories", :notice => 'Category Updated Succesfully.' ) and return
                 end    
             else
                 redirect_to("/admin/categories/new",  :flash => { :error => 'Upload JPEG, PNG or GIF Image only.' } ) and return
                 
              
             end 
           end     
         end   
    end
    
      def update
          update! do 
                       
                if params[:upload]
                    num1 = 'category_'+params[:id]
                    name = num1+'_'+params[:upload]['datafile'].original_filename
                    directory = "public/data/orig/category"
                    
                      ext = params[:upload]['datafile'].original_filename.split(".")
                
                   if ext[1]=='jpg' || ext[1]=='jpeg' || ext[1]=='png' || ext[1]=='gif'  || ext[1]=='JPG' || ext[1]=='JPEG' || ext[1]=='PNG' || ext[1]=='GIF'  
                      path = File.join(directory, name)
                      
                      File.open(path, "wb") { |f| f.write(params[:upload]['datafile'].read) }
                     
                      Category.update_all(['category_image=?', name],['id=?',params[:id]])
                      @category = Category.find(params[:id])
                      if @category[:category_parent_id]==0
                          redirect_to("/admin/categories", :notice => 'Category Updated Succesfully.' ) and return
                      else
                        redirect_to("/admin/categories/child_categories/"+@category[:category_parent_id].to_s, :notice => 'Child Category Updated Succesfully.' ) and return
                       end       
                   else
                    redirect_to("/admin/categories/"+params[:id].to_s+"/edit",  :flash => { :error => 'Upload JPEG, PNG or GIF Image only.' } ) and return
                   end   
                   
                   
            end
         end
      end
         
      def list
        @page_title = 'Category List'+SiteSetting.site_title
        
        render "category_list" , :layout => 'active_admin'
        
      end
      
      def delete_categories
          @categories = Category.find(params[:id])
          ref_id = @categories[:category_parent_id]       
     
          @categories.destroy
     
          redirect_to(:action => 'child_categories/'+ref_id.to_s, :notice => 'Categories was successfully destroyed.')
      end
      
      def child_categories
         @category = 'Category list'
         @page_title = 'Category List'+SiteSetting.site_title
          render "category_list" , :layout => 'active_admin'
        
        #redirect_to "category_list"+params[:id].to_s, :notice => 'Event Deactivated Successfully.'
      end
   end
   
          filter :category_name
        
       form :html => { :enctype => "multipart/form-data" } do |f|
         if params[:parent_id].to_i!='' && params[:parent_id].to_i > 0
           category[:category_parent_id] = params[:parent_id].to_i
         end
            
           f.inputs "Category Details" do
             
           
                  f.input :category_name
                  f.input :category_description                 
                  f.input :category_status,:as => :select,:include_blank => false, :collection =>[["Active", 1],["Inactive", 0]]
                  #f.input :category_image, :as => :file, :input_html => { :name => 'upload[datafile]' }       
                  
                   if f.object.new_record?  || category.category_image=='' || category.category_image==nil     
                        f.input :category_image, :as => :file, :input_html => { :name => 'upload[datafile]' } 
                   else
                        f.input :category_image, :as => :file, :input_html => { :name => 'upload[datafile]' }, :hint => f.template.image_tag(APP_CONFIG['development']['upload_url']+'data/orig/category/'+category.category_image, :width => '150', :height => '150')    
                   end
                         
                  f.input :category_parent_id, :as => :hidden
                  
         
            f.buttons do
            f.action(:submit) 
            end                                                
            
        end
    end
end