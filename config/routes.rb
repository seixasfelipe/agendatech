Agendatech::Application.routes.draw do
  resources :authentications

  devise_for :users

  devise_for :admins
  namespace :admin do 
    root :to => 'admin#index'
    resources :eventos, :only => [:index,:update] do
      member do
        get 'aprovar'
        get 'desaprovar'
        get 'copiar'
        get 'remover' 
      end
    end
    resources :grupos, :only => [:index,:update,:destroy] do 
      member do
        put 'aprovar'
      end
    end
  end

  match '/auth/:provider/callback' => 'authentications#create'
  match 'gadgets/:evento/:tipo' => 'gadgets#create', :as => :gadgets
  match 'rss/feed.:format' => 'rss#feed', :as => :feed
  match '/' => 'eventos#index'
  resources :eventos, :path_names => {:new => 'novo', :edit => 'editar'}
  root :to => 'eventos#index'
  resources :comentarios
  match 'calendario/eventos' => 'calendario#index', :as => :calendario
  match 'calendario/eventos/:estado' => 'calendario#index', :as => :calendario_por_estado
  resources :grupos
  match 'colaboradores' => 'sobre#colaboradores', :as => :colaboradores
  match 'mobile/eventos' => 'mobile#eventos', :format  => :json
  match 'mobile/grupos' => 'mobile#grupos', :format  => :json  
  match 'contato' => 'notifier#index', :as => :contato
  match 'sobre' => 'sobre#index', :as => :sobre
  match 'calendario' => 'calendario#links', :as => :calendario_link
  match 'eventos/tecnologia/:ano/:id' => 'eventos#show', :as => :evento
  match 'grupos/:nome/:id/eventos' => 'grupos#show', :as => :grupo
  match 'busca/eventos/:estado' => 'eventos#index', :as => :eventos_por_estado
  match 'busca/eventos/:ano/:month' => 'eventos#index', :as => :eventos_por_mes
  match 'cursos/tecnologia/:ano' => 'eventos#cursos', :as => :cursos
  match 'eventos/lista/:evento_name' => 'eventos#lista'
  match 'atividades/:nick' => 'atividades_do_usuario#index', :as => :atividades_do_usuario
  match '/:controller(/:action(/:id))'
end

