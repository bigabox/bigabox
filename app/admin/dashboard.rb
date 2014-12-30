ActiveAdmin.register_page "Dashboard" do
  menu false
  #menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }
  
  content :title => 'Dashboard'+SiteSetting.site_title do
      render "index" , :layout => 'active_admin'
  end # content
   
end
