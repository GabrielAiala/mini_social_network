class ApplicationController < ActionController::API
  include Pagy::Backend

  before_action :authenticate_request

  private

  def authenticate_request
    header = request.headers["Authorization"]
    token = header&.split(" ")&.last

    decoded = JsonWebToken.decode(token)

    if decoded
      @current_user = User.find_by(id: decoded[:user_id])
      render json: { error: "não autorizado" }, status: :unauthorized unless @current_user
    else
      render json: { error: "token inválido ou ausente" }, status: :unauthorized
    end
  end
end
