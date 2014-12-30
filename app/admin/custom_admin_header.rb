class CustomAdminHeader < ActiveAdmin::Views::Header
  include Rails.application.routes.url_helpers

  def build(namespace, menu)
    #div  do
      # Add one item without son.
      
     
      h1 :id => 'site_title', :class => 'site_title' do
       link_to image_tag('rockerslogo.png', :title => SiteSetting.site_title), :controller => 'dashboard'
      end
        
      ul :id => 'tabs', :class => 'header-item tabs' do
        # Replace route_destination_path for the route you want to follow when you receive the item click.
         li { link_to 'Dashboard', :controller => 'dashboard' }
=begin
    li :class => 'has_nested' do
    text_node link_to("Dashboard", "#")

      ul do
          li { link_to 'Dashboard', :controller => 'dashboard'  }
          #li { link_to 'Version', {:controller => 'versions', :action => '1/edit'}, :class => 'rr'}
          li { link_to 'Version', :controller => 'versions'}
      end
     
    end 
=end               
        
        li { link_to 'Admin Users', :controller => 'admin_users' }
        
        li { link_to 'Users', :controller => 'users' }
        
        li { link_to 'Events', :controller => 'events' }
        
        li { link_to 'Pages', :controller => 'pages' }
        
        li :class => 'has_nested' do
          text_node link_to("Transactions", "#")
          ul do
            li { link_to 'All Transactions',  :controller => 'purchases' }
            li { link_to 'Monthly Transactions',  :controller => 'purchases', :action => 'monthly/list' }
            li { link_to 'Yearly Transactions',  :controller => 'purchases', :action => 'yearly/list' }
            # If you want to add more children, include more LIs here.
          end
        end
        
        li :class => 'has_nested' do
          text_node link_to("Manage Settings", "#")
          ul do
            li { link_to 'Site Setting',  :controller => 'site_settings' }
            li { link_to 'Site Themes',  :controller => 'site_themes' }
            li { link_to 'Facebook Setting',  :controller => 'facebook_settings' }
            li { link_to 'Twitter Setting',  :controller => 'twitter_settings' }
            
            li { link_to 'PayPal Setting',  :controller => 'paypal_settings' }
            li { link_to 'Authorize Setting',  :controller => 'authorize_settings' }
            li { link_to 'Wallet Setting',  :controller => 'wallet_settings' }
            
            li { link_to 'Currency Codes',  :controller => 'currency_codes' }
            #li { link_to 'Languages',  :controller => 'languages' }
            li { link_to 'Email Preferences',  :controller => 'email_preferences' }
            li { link_to 'Newsletter Templates',  :controller => 'newsletter_templates' }
            li { link_to 'Newsletter Job',  :controller => 'newsletter_jobs' }
            li { link_to 'Email Templates',  :controller => 'email_templates' }
            li { link_to 'Tips Setting',  :controller => 'tips' }
            li { link_to 'All Categories',  :controller => 'categories' }
            
            # If you want to add more children, including more LIs here.
          end
        end
        
        li :class => 'has_nested' do
          text_node link_to("Manage Wallet", "#")
          ul do
            li { link_to 'Pending Withdrawals',  :controller => 'wallet_withdraws' }
            li { link_to 'Confirm Withdrawals',  :controller => 'wallets' }
            
            # If you want to add more children, including more LIs here.
          end
        end
        
        li :class => 'has_nested' do
        
          text_node link_to("Cancelled Orders", "#")
          ul do
            li { link_to 'Pending Cancelled Orders',  :controller => 'cancel_orders' }
            li { link_to 'Confirm Cancelled Orders',  :controller => 'cancel_orders' , :action => 'confirms/list' }
            
          end
        end
        
        
      end

     
    super(namespace, menu)
     script do
         render :inline => "
         var server_url = '"+APP_CONFIG['development']['js_url']+"js/ckeditor';
         $(document).ready(function() 
                           {  
                            
                            $('.breadcrumb').html('');
                           });"
      end
       
    #end
  end
end