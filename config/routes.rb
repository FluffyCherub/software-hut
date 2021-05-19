Rails.application.routes.draw do
  
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
  match "/student/groups", to: "pages#student_groups_join", via: :all
  match "/feedback/matrix", to: "feedback#feedback_matrix", via: :all
  match "/feedback/review/all", to: "feedback#feedback_review_all", via: :all
  match "/feedback/review/all/save", to: "feedback#save_feedback", via: :all
  match "/feedback/review/all/approve", to: "feedback#approve_feedback", via: :all
  match "/feedback/mailmerge/edit", to: "feedback#feedback_mailmerge_edit", via: :all
  match "/problem_notes", to: "problem_notes#create", via: :all
  match "/admin/modules/preview/import_users", to: "admin#import_users_csv", via: :all
  match "/student/profile", to: "pages#student_profile", via: :all
  match "/admin/modules/groups/approve", to: "admin#approve_teams", via: :all
  match "/admin/modules/periods/edit", to: "admin#admin_modules_periods_edit", via: :all
  match "/edit/feedback/periods", to: "admin#edit_feedback_periods", via: :all
  match "/student/profile/feedback/old", to: "pages#student_profile_feedback_old", via: :all
  match "/student/profile/docs/old", to: "pages#student_profile_docs_old", via: :all
  match "/student/profile/select/module", to: "pages#student_profile_select_module", via: :all
  match "/feedback/old/show", to: "pages#feedback_old_show", via: :all
  match "/send/feedback/mailmerge", to: "admin#send_feedback_mailmerge", via: :all
  match "/remove/student/from/team", to: "admin#remove_student_from_team", via: :all
  match "/assign/solve/problem", to: "admin#assign_solve_problem", via: :all
  match "/add/individual/user", to: "admin#add_individual_user", via: :all
  match "/admin/modules/groups/docs", to: "admin#admin_modules_groups_docs", via: :all
  
  


  



  get :ie_warning, to: 'errors#ie_warning'
  get :javascript_warning, to: 'errors#javascript_warning'



  root to: "pages#index"

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
