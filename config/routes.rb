# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # root to: "application#index"

  authenticated :user do
    root to: 'picks#standings', as: :authenticated_root
  end
  root to: 'landing#landing_page'

  get '/rules' => 'static_pages#rules', as: :rules
  get '/table' => 'epldata#table', as: :epl_table
  get '/schedule' => 'epldata#schedule', as: :epl_sched
  get '/schedule/:matchday' => 'epldata#matchday', as: :matchday
  get '/welcome' => 'static_pages#guest_welcome', as: :welcome
  get '/mypicks/g' => 'static_pages#guest_mypicks', as: :gpicks
  get '/standings' => 'picks#standings', as: :standings
  get '/mypicks' => 'picks#mypicks', as: :mypicks

  # Pick form
  patch '/mypicks/:pick_id' => 'picks#make', :as => :pick
  devise_scope :user do
    patch '/mypicks_update' => 'users/update_picks#update_picks', :as => :update_picks
  end
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
end
