Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


  root to: 'metrics#index'

  delete '/delete', :to => 'application#delete', as: :delete

  resources :assignments, :metrics, :suites, :users
  resources :tests do
    resources :results
    collection do
      match 'import' => 'tests#import', via: [:get, :post]
    end
  end
  get 'incomplete' => 'results#incomplete', as: :incomplete
  get 'generic_tester' => 'results#generic_tester', as: :generic_tester
end
