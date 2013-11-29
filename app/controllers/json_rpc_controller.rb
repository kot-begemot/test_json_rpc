require 'net/https'
require 'uri'

class JsonRpcController < ActionController::Base
  before_action :process_params
  respond_to :json

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: { error: "Not Found" }, status: 404
  end

  def login
    user = User.find_by_email!(user_email)
    if user.valid_password?(user_password)
      render json: { auth_token: user.authentication_token, email: user.email }, status: 202
      return
    else
      render json: { error: "Unauthorized" }, status: 401
    end
  end

  def add
    user = User.find_by_authentication_token!(user_token)

    if result = joyrock_server.add(params.require(:a), params.require(:b))
      render json: { result: result }, status: 200
    else
      render json: { error: joyrock_server.error["message"] }, status: 500
    end
  end

  protected

  # Pars data provided inside request body
  def json_data
    @data ||= JSON.parse(request.body.read)
  end

  # Replace request params with JSON data provided within request body
  def process_params
    self.params = ActionController::Parameters.new json_data
  end

  def user_email
    params.require(:user).require(:email)
  end

  def user_password
    params.require(:user).require(:password)
  end

  def user_token
    params.require(:auth_token)
  end

  def joyrock_server
    @joyrock_server ||= ::Joyrock.new
  end
end
