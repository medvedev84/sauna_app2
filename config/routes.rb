SaunaApp::Application.routes.draw do 
	resources :saunas
	resources :sauna_items
	resources :sauna_comments
	resources :bookings	
	resources :sms_messages	
	resources :sauna_photos	
  
	match '/signout', :to => 'admin/sessions#destroy'
	match '/signin',  :to => 'admin/sessions#new'

	match '/faq', :to => 'pages#faq'
	match '/contact', :to => 'pages#contact'
	match '/about',   :to => 'pages#about' 
 	match '/incorrect',   :to => 'pages#incorrect' 
	match '/terms',   :to => 'pages#terms' 
	match '/all', :to => 'pages#all'
	match '/howto',   :to => 'pages#howto'
	match '/mobile-app',   :to => 'pages#mobile-app'
	match '/adv', :to => 'pages#advertisement'
	
	match '/chto-vzyat',   :to => 'pages#chto-vzyat'
	match '/polza-ili-vred',   :to => 'pages#polza-ili-vred'
	match '/sauna-ili-banya',   :to => 'pages#sauna-ili-banya'
	
	match '/cities',   :to => 'cities#index'
	match '/advertisements',   :to => 'advertisements#index'
	
	match '/izhevsk',   :to => 'cities#izhevsk'
	match '/sarapul',   :to => 'cities#sarapul'
	match '/votkinsk',   :to => 'cities#votkinsk'
	match '/glazov',   :to => 'cities#glazov'
	match '/mozhga',   :to => 'cities#mozhga'
	match '/kirov',   :to => 'cities#kirov'
	match '/kazan',   :to => 'cities#kazan'
	match '/nizhnekamsk',   :to => 'cities#nizhnekamsk'
	match '/neftekamsk',   :to => 'cities#neftekamsk'
	match '/chelni',   :to => 'cities#chelni'
	match '/yola',   :to => 'cities#yola'
	match '/sterlitamak',   :to => 'cities#sterlitamak'
	match '/perm',   :to => 'cities#perm'
	match '/ufa',   :to => 'cities#ufa'
		
	match '/map',   :to => 'maps#index'
	
	match '/m', :to => redirect("/?mobile=1")
	match '/pda', :to => redirect("/?mobile=2")
 
	root :to => 'saunas#index'
  
	match '/admin/sauna/:id/sauna_items' => 'admin/sauna_items#index'
	match '/admin/sauna/:id/sauna_photos' => 'admin/sauna_photos#index'
	match '/admin/sauna/:id/sauna_comments' => 'admin/sauna_comments#index'
	match '/admin/sauna/:id/bookings' => 'admin/bookings#index'

	match '/sms/status', 			:to => "sms_messages#status"

	# TODO!
	match '/admin/sauna_photos?:id' => 'admin/sauna_photos#update'
	
    namespace :admin do
		# Directs /admin/products/* to Admin::ProductsController
		# (app/controllers/admin/products_controller.rb)
		resources :users
		resources :sessions, :only => [:new, :create, :destroy]
		resources :saunas
		resources :sauna_items
		resources :sauna_comments
		resources :sauna_photos
		resources :sms_messages		
		resources :bookings	
		resources :payments	
		resources :external_payments
		resources :site_settings
		resources :advertisements
		resources :coupon_urls
		resources :coupon_deals		
	end  

	# to walk around standart rails routing
	match 'payments/result',		:to => "payments#result"
	match 'payments/success', 		:to => "payments#success"
	match 'payments/fail', 			:to => "payments#fail"
	match 'payments/daily', 		:to => "payments#daily_process"	
	match 'coupons/daily', 			:to => "coupon_deals#daily_process"	
	match 'coupons/index', 			:to => "coupon_deals#index"	
	
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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
