Rails.application.routes.draw do
  scope module: 'public' do
    root :to => 'homes#top'
    get 'about' => 'homes#about'
    resource :customers, only: [:edit, :update] do
      get 'my_page' => 'customers#show'
      get 'out_confirm' => 'customers#out_confirm'
      patch 'out' => 'customers#out'
    end
    devise_for :customers, only: [:sessions, :registrations]
    resources :products, only: [:index, :show]
    resources :cart_products, only: [:index, :update, :create, :destroy] do
      collection do
        delete 'destroy_all'
      end
    end
    resources :orders, only: [:index, :show, :new, :create] do
      collection do
        post 'confirm'
        get 'thanks'
      end
    end
    resources :addresses, only: [:index, :create, :edit, :update, :destroy]
  end

  devise_for :admins, path: '/admin', only: [:sessions], controllers: {
    :sessions => 'admin/sessions'
  }
  namespace :admin do
    root :to => 'homes#top'
    resources :products, only: [:index, :new, :create, :show, :edit, :update]
    resources :genres, only: [:index, :create, :edit, :update]
    resources :customers, only: [:index, :show, :edit, :update]
    resources :orders, only: [:show, :update]
    resources :order_details, only: [:update]
  end
end