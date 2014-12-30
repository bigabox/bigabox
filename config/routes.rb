Eventdemo::Application.routes.draw do
 
  match '/tickets/payment', :to => 'tickets#payment', :as => 'ticketspayment', :via => [:get]
  match '/tickets/relay_response', :to => 'tickets#relay_response', :as => 'tickets_relay_response', :via => [:post]
  match '/tickets/receipt', :to => 'tickets#receipt', :as => 'tickets_receipt', :via => [:get]
 
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'home#index'
  
  ActiveAdmin.routes(self)
  devise_for :admin_users, ActiveAdmin::Devise.config
  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  match ':controller(/:action(/:id))(.:format)'
    
    #resources :contacts do
     # collection { post :import }
    #end
    
    
  match 'content/:id' => 'pages#index', :as => :id
  
  match 'event/:id' => 'events#custom_url', :as => :id
  match 'org/:id' => 'organizers#custom_url', :as => :id
  match 'referrer/:id' => 'referrers#user', :as => :id
  match 'affiliate/:id' => 'affiliates#events', :as => :id


  match 'ADMIN' => 'admin/admin_users#index'

  match 'admin/wallet_withdraws/confirm' => 'admin/wallet_withdraws#confirm'
  match 'admin/cancel_orders/confirm_cancel' => 'admin/cancel_orders#confirm_cancel'
  

 #match '*path' => redirect('home/') unless Rails.env.development?
 # map.connect '*', :controller => 'home', :action => 'index'
 
 match 'logout' => 'home#logout'
  
  unless Rails.application.config.consider_all_requests_local
    match '*not_found', :to => 'errors#error_404'
    match '*internal_error', :to => 'errors#error_500'
  end
 

#  match '*a', :to => 'errors#routing'

end