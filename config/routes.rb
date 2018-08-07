Rails.application.routes.draw do

  devise_for :users, controllers: { registrations: 'users/registrations' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # root to: "application#index"

  authenticated :user do
  root :to => 'picks#standings', as: :authenticated_root
  end
  root :to => 'application#home'

  get '/table' => "epldata#table", as: :epl_table
  get '/schedule' => "epldata#schedule", as: :epl_sched

  get '/standings' => 'picks#standings', as: :standings
  get '/mypicks' => 'picks#mypicks', as: :mypicks

  # Pick form
  patch '/mypicks/:pick_id' => "picks#make", :as => :pick
end
