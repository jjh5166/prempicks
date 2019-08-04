# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
  authenticated :user do
    root to: 'picks#mypicks', as: :authenticated_root
  end
  root to: 'landing#landing_page'

  get '/rules' => 'static_pages#rules', as: :rules
  get '/table' => 'epldata#table', as: :epl_table
  get '/schedule/:matchday' => 'epldata#schedule', as: :schedule
  get '/standings' => 'picks#standings', as: :standings
  get '/mypicks' => 'picks#mypicks', as: :mypicks

  #Guest Views
  get '/welcome' => 'static_pages#guest_welcome', as: :welcome
  get '/mypicks/g' => 'picks#guest_mypicks', as: :gpicks
  get '/standings/g' => 'picks#guest_standings', as: :gstandings

  devise_scope :user do
    patch '/mypicks_update' => 'users/update_picks#update_picks', :as => :update_picks
    patch '/gpicks_update' => 'users/update_picks#update_guest_picks', :as => :update_guest_picks
  end
end
