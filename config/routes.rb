Maawol::Engine.routes.draw do
	root to: 'home#index'

	get "foo", to: "home#index", as: :foo

	resources :passwords, controller: "passwords", only: [:create, :new]
	resource :session, controller: "sessions", only: [:create]

	resources :users, controller: "users", only: [:create] do
		resource :password, controller: "passwords", only: [:edit, :update]
	end

	get "sign_in" => "sessions#new", as: "sign_in"
	delete "sign_out" => "sessions#destroy", as: "sign_out"
	get "sign_up" => "users#new", as: :sign_up
end