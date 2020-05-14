Rails.application.routes.draw do
  default_url_options :host => Maawol::Config.site_host

	root to: 'home#index'

	resources :passwords, controller: "passwords", only: [:create, :new]
	resource :session, controller: "sessions", only: [:create]

	resources :users, controller: "users", only: [:create] do
		resource :password, controller: "passwords", only: [:edit, :update]
	end

	get "sign_in" => "sessions#new", as: "sign_in"
	delete "sign_out" => "sessions#destroy", as: "sign_out"
	get "sign_up" => "users#new", as: "sign_up"

	namespace :admin do
	  resources :users
	  resources :subscribers
	  resources :comps
	  resources :authors
	  resources :lessons
	  resources :videos
	  resources :audio_files
	  resources :downloadables
	  resources :stores
	  resources :product_payments
	  resources :subscription_options
	  resources :users_subscription_payments
	  resources :courses
	  resources :root_categories
	  resources :categories
	  resources :tags
	  resources :skill_levels
	  resources :playlists
	  resources :albums
	  resources :stuck_questions
	  resources :income_reports, only: [:index, :show]
	  namespace :content_management do
	    resources :content_blocks
	    resources :pages
	    resources :images
	    get "edit_nav/:slug", to: "navbars#edit", as: :edit_navbar
	    patch "edit_nav/:id", to: "navbars#update", as: :navbar
	  end
	  resources :site_settings
	  resources :site_images
	  patch "set_homepage_video", to: "videos#set_for_homepage"
	  get "resource-counts", to: "resource_counts#index"
	  root to: "lessons#index"
	end

	post 'tmp-media', to: 'tmp_media#create'
	delete 'tmp-media/:id', to: 'tmp_media#destroy'

	resources :lessons
	resources :courses
	resources :views
	resources :watch_laters
	resources :favourites
	resources :settings
	resources :comments
	patch  "update_password", to: "settings#update_password"

	get 'home' => 'dashboard#index'
	get 'dashboard' => 'dashboard#index', as: :dashboard
	get 'lesson-request' => 'contact#new', lesson_request: true
	get 'stuck' => 'contact#new', stuck: true
	get 'contact' => 'contact#new', as: :new_contact
	post 'contact' => 'contact#create', as: :contacts
	get 'categories' => 'categories#index'
	patch 'card_details', to: 'card_details#update', as: :update_card_details

	get 'paypal/success', to: 'paypal_callback#create'
	get 'paypal/cancel', to: 'paypal_callback#destroy', as: :cancel_paypal_payment

	resources :subscriptions
	get 'subscribe' => 'subscriptions#new', as: :subscribe
	post 'subscription_discount', to: 'subscription_discounts#create'
	get 'subscription_discount', to: 'subscription_discounts#show'
	get 'subscription_options', to: 'subscription_options#index'
	get 'subscription_option/:id', to: 'subscription_options#show'

	post "chargebee", to: "chargebee_webhooks#router"
	post "paypal/webhook", to: "paypal_callback#webhooks_router"

	get "products", to: "products#index"
	get "basket", to: "basket#show"
	patch "add_product_to_basket", to: "basket#update", method: :add
	patch "remove_product_from_basket", to: "basket#update", method: :remove
	delete "clear_basket", to: "basket#destroy"
	get "file/:token", to: "downloadables#show", as: :download_file
	get "audio_file/:token", to: "audio_files#show", as: :download_audio_file
	get "checkout", to: "checkout#new", as: :checkout
	get "checkout/paypal/cancel", to: "checkout#new", paypal_cancelled: true
	get "single-checkout/:token", to: "checkout#new", as: :file_basket
	post "checkout", to: "checkout#create", as: :process_checkout
	get "checkout-complete", to: "checkout#show", as: :checkout_complete
	get "checkout/paypal/success", to: "checkout#update"

	get "/store/:slug", :to => "stores#show", as: :store

	get "*slug", to: "content_management/pages#show", as: :cms_page, constraints: lambda { |req|
	  req.path.exclude? 'amazonaws.com'
	}
end