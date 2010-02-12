ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'login'
  map.logout '/logout', :controller => 'login', :action => 'logout'

  map.resources :orders, :only => [:index, :show], :member => {:preview => :get, :print => :post, :snailpad_print => :post}, :collection => { :snailpad_api_key => :post }
  map.resources :print_templates, :as => 'templates'
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
