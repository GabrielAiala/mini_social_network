class LikesController < ApplicationController
  def create
    like = Like.find_by(user: @current_user, post_id: like_params[:post_id])
    if like
      like.destroy
      render json: { message: "Like removido com sucesso" }, status: :ok
    else

      @like = Like.new(like_params)
      @like.user = @current_user

      if @like.save
        render json: @like, status: :created
      else
        render json: { errors: @like.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end
  private

  def like_params
    params.require(:like).permit(:post_id)
  end
end
