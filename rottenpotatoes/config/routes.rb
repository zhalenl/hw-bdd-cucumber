Rottenpotatoes::Application.routes.draw do
  resources :movies
  # map '/' to be a redirect to '/movies'
  get '/movies/:id/search', :to => 'movies#search', :as => :search
  root :to => redirect('/movies')
  
end
