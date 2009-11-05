ActionController::Routing::Routes.draw do |map|
  map.resources :tasks, :collection => { :reorder => :put }
  map.resources :lists, :collection => { :reorder => :put } do |list|
    list.resources :tasks, :collection => { :reorder => :put }
  end
end
