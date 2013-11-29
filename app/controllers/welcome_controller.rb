class WelcomeController < ApplicationController
  before_filter :authenticate_user!, only: [:user_index]

  def index
  end

  def user_index
  end
end
