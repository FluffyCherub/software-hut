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
  match "/tmr", to: "tmr#tmr_doc", via: :all
  match "/admin", to: "admin#admin_page", via: :all
  match "/admin/privileges", to: "admin#admin_privileges", via: :all
  match "/admin/modules", to: "admin#admin_modules", via: :all
  match "/admin/modules/preview", to: "admin#admin_modules_preview", via: :all
  match "/admin/modules/create", to: "admin#admin_modules_create", via: :all
  match "/module_handbook", to: "pages#module_handbook", via: :all
  match "/admin/modules/edit", to: "admin#admin_modules_edit", via: :all
  match "/admin/modules/privilege", to: "admin#admin_modules_privilege", via: :all
  match "/admin/modules/groups", to: "admin#admin_modules_groups", via: :all
  match "/admin/modules/groups/preview", to: "admin#admin_modules_groups_preview", via: :all
  match "/admin/modules/groups/add", to: "admin#admin_modules_groups_add", via: :all
  match "/admin/modules/groups/create", to: "admin#admin_modules_groups_create", via: :all


  get :ie_warning, to: 'errors#ie_warning'
  get :javascript_warning, to: 'errors#javascript_warning'



  root to: "pages#index"

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
