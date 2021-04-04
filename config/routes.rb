Rails.application.routes.draw do
  
  #get 'toa/toa_doc'
  mount EpiCas::Engine, at: "/"
  devise_for :users
  match "/403", to: "errors#error_403", via: :all
  match "/404", to: "errors#error_404", via: :all
  match "/422", to: "errors#error_422", via: :all
  match "/500", to: "errors#error_500", via: :all
  match "/modules", to: "pages#modules", via: :all
  match "/toa", to: "toa#toa_doc", via: :all
  match "/toa/locked", to: "toa#toa_doc_locked", via: :all
  match "/admin", to: "admin#admin_page", via: :all


  get :ie_warning, to: 'errors#ie_warning'
  get :javascript_warning, to: 'errors#javascript_warning'



  root to: "pages#index"

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
