class ApplicationController < ActionController::Base
  before_action :authenticate_request

  attr_reader :current_user

  private

  def authenticate_request
    header = request.headers["Authorization"]
    token = header&.split(" ")&.last # formato: "Bearer <token>"

    decoded = JsonWebToken.decode(token)

    if decoded
      @current_user = User.find_by(id: decoded[:user_id])
      render json: { error: "não autorizado" }, status: :unauthorized unless @current_user
    else
      render json: { error: "token inválido ou ausente" }, status: :unauthorized
    end
  end
end
