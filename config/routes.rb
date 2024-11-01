Rails.application.routes.draw do

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'static#index'
  get 'admin' => 'static#admin'
  get 'members/:id/show_wallet_link', to: 'members#show_wallet_link', as: 'show_wallet_link'
  resources :afns_class_schedules do
    resources :afns_class_attendances, only: [:new, :create, :edit, :update]
    
    member do
      get 'show_with_attendance'
    end
  end


  resources :members
  resources :lockers do
    collection do
      get 'new_men', to: 'lockers#new_men'
      get 'new_women', to: 'lockers#new_women'
    end
    member do
      get 'edit_men', to: 'lockers#edit_men'
      get 'edit_women', to: 'lockers#edit_women'
    end
  end
  resources :trainer_forms

  resources :guest_agreements
  resources :afns_classes
  resources :waivers
end
