#require 'curb'
#require 'curl'
#require 'xmlsimple'
#require 'open-uri'
#require 'archive/zip'
#require 'active_support/core_ext/object/to_query'


ActiveAdmin.register Version do
  
  menu false
  
   config.batch_actions = false
   config.clear_action_items!
   config.filters = false
   
 controller do  
      
 def index

      @version = SiteSetting.find(:first) 
     
      http = Curl.post("http://airtaskerclone.com/versions/api/example/process/", {:version_no => @version[:site_version], :version_license=> @version[:version_license], :version_pcode => @version[:version_pcode], :domain => "sdf", :type => "check_version"})
      
            
     @xml_res = http.body_str
      
      @dirpath = Dir.pwd         # Output : C:/Sites/halfevent

   # ---- Create xml file and write response to it ---- # 
   
   if File.directory?('xml_files')
      create_xml                # Method contains code to re-write xml file
   else
     Dir.mkdir("xml_files")     # If directory doesn't exist, create new directory
     create_xml
   end  

  # ---- Read XML File ---- #
  
   config = XmlSimple.xml_in("#{@dirpath}/xml_files/version_control.xml") # Read xml file
   #if config['error'][0]['errormsg']
   #  @notice = config['error'][0]['errormsg'][0]
   
   #else     
     @version_number = config['userdata'][0]['version']       
   
   # ----- Save to db ----- #      
      @version = SiteSetting.find(:all, :conditions =>['site_version = ?', @version_number[0]])
       if @version  
           if !@version.empty?                  
             @flag = 1
         else
             @flag = 0
         end
       end             

  # end  # end outer if 
    render "version_index" , :layout => 'active_admin' 
 
 end  # end index
# ============== End of INDEX =============== #   
  def update      
  # ---- Read XML File ---- #
  @dirpath = Dir.pwd           # Output : C:/Sites/halfevent
   
   config = XmlSimple.xml_in("#{@dirpath}/xml_files/version_control.xml") # Read xml file
   url = config['userdata'][0]['filepath']
   @version_number = config['userdata'][0]['version']
   @license = config['userdata'][0]['license']
   
   @filename = File.basename(url[0], "_.zip")         # Get only filename from file path
   @file = open(url[0])
 
  # ----- unzip/zip ----- #
  
  if Dir.exists?('versions') # Checks if directory exists
    zip_unzip                # Contains code to extract remote zip to specific location and create a backup of zip file 
 
  else        
    Dir.mkdir("versions")    # If directory does not exist, create new dir 
    zip_unzip                # Contains code to extract remote zip to specific location and create a backup of zip file      
  end  
  
  # ----- Save to db ----- #
   
   @version = SiteSetting.find(:first)
  
   site_version = @version_number[0].to_s
   version_license = @license[0].to_s
 
   SiteSetting.update_all(:site_version => site_version, :version_license => version_license)
    
   @notice = "Version Updated successfully!!" 
   
   render "version_list" , :layout => 'active_admin'    
 end
 
# ============== End of UPDATE =============== #   


# ============== Code to Unzip remote folder and create zip file as backup =============== #    
  private
  def zip_unzip   
    @dirpath = Dir.pwd           # Output : C:/Sites/halfevent
    
    @destination = "#{@dirpath}/versions"     
    @dest2 = "#{@destination}/backup_#{@filename}.zip"
    
    Archive::Zip.extract(@file, @destination)                       # Extract zip to specified location
    Archive::Zip.archive(@dest2, "#{@destination}/#{@filename}")    # Create "zipped" backup of the extracted foler
  end  
  
# ================= End of Zip/Unzip code ================== #
 
# ============== Code to Write XML response to XML File =============== #  
  private
  def create_xml    
     @aFile = File.new("#{@dirpath}/xml_files/version_control.xml", "w")
        
     if @aFile
       @aFile.syswrite(@xml_res)
     else
       puts "Unable to open file!"
     end   
     @aFile.close
  end
  # ============== End of Write to XML code =============== #   
   
 end # end controller do
 

end