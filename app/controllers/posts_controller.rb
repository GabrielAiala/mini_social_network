class PostsController < ApplicationController
  def create
    @post = Post.new(post_params)
    @post.user = @current_user

    if @post.save
      render json: @post, status: :created
    else
      render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def following
    @paggy, @posts = pagy(Post.where(user: @current_user.following).order(created_at: :desc))
    render json: @posts
  end

  private

  def post_params
    params.require(:post).permit(:content)
  end
end
