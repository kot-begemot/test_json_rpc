TestJsonRpc::Application.routes.draw do
  devise_for :users

  controller :json_rpc do
    post :login
    post :add
  end

  root to: "welcome#index"
end
