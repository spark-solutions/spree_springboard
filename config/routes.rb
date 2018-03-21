Rails.application.routes.draw do
  Spree::Core::Engine.add_routes do
    namespace :admin do
      resources :springboard_logs
      patch 'orders/:id/springboard_export', to: 'orders#springboard_export', as: 'springboard_export'
    end
  end
end
