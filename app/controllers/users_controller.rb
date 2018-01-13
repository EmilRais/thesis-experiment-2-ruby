class UsersController < ApplicationController
  before_filter :authenticate, only: [:show, :update, :destroy]
  before_action :fetch_user, only: [:show, :update, :destroy]
  
  def create
    @user = User.create(params.permit(:name, :age, :password))
    if @user
      render json: @user, status: :created
    else
      head :bad_request
    end
  end
  
  def index
    @users = User.skip(params[:offset]).limit(params[:limit]).all
    render json: @users.map { |u| { id: u.id, name: u.name } }
  end
  
  def show
    if valid_user?
      render json: @user
    else
      head :bad_request
    end
  end
  
  def update
    if valid_user? && @user.update(params.permit(:age, :password))
      head :ok
    else
      head :bad_request
    end
  end
  
  def destroy
    if valid_user? && @user.destroy
      head :ok
    else
      head :bad_request
    end
  end
  
  private
  def fetch_user
    @user = User.find(params[:id])
  end
  
  def authenticate
    authenticate_or_request_with_http_basic do |name, password|
      @username = name
      User.where(name: name, password: password).exists?
    end
  end
  
  def valid_user?
    @user && @user.name == @username
  end
end
