TestJsonRpc::Application.routes.draw do
  devise_for :users

  controller :json_rpc do
    post :login
    post :add
  end

  get "welcome", to: "welcome#user_index", as: :user_root
  root to: "welcome#index"
end
