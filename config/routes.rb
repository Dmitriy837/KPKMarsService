KPKMarsService::Application.routes.draw do

  get "sessions/new"

  get "log_out" => "sessions#destroy", :as => "log_out"
  get "log_in" => "sessions#new", :as => "log_in"
 
  root :to => "admin_room#index"
  
  get "admin_room" => "admin_room#index", as: "admin_room"
  
  resources :users do
    resources :firms do
      resources :devices
      resources :ftp_servers
      resources :parameters
    end
  end

  resources :sessions
end
