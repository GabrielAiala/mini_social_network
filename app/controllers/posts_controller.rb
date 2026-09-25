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
    posts = Post
      .where(user: [ @current_user.following, @current_user ])
      .joins(:user)
      .select("posts.*, users.name as user_name")
      .order(created_at: :desc)

    @pagy, @posts = pagy(posts)
    render json: {
      posts: @posts,
      pagination: pagy_metadata(@pagy)
    }
  end

  private

  def post_params
    params.require(:post).permit(:content)
  end
end
