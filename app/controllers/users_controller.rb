class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: [ :create ]

  def create
    user = User.new(user_params)

    if user.save
      token = JsonWebToken.encode(user_id: user.id)
      render json: { token: token, user: user_response(user) }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def index
    users = User.where.not(id: @current_user.id)
                      .where("name ILIKE ?", "%#{search_params[:name]}%")
                      .select(:id, :name, :email)
    render json: users, status: :ok
  end

  def show
    user = User.find(params[:id])
    render json: user_response(user), status: :ok
  end

  private

  def user_params
    params.permit(:name, :email, :password, :password_confirmation)
  end

  def user_response(user)
    { id: user.id, name: user.name, email: user.email }
  end

  def search_params
    params.permit(:name)
  end
end
